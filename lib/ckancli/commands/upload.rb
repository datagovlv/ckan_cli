# frozen_string_literal: true

require 'colorize'
require 'pathname'
require 'csvlint'
require 'json'
require 'tty-logger'
require 'tty-spinner'
require 'net/smtp'
require 'mail'
require 'open-uri'
require 'uri'

require_relative '../command'
require_relative '../../ckanclient/ckanclient'

module Ckancli
  module Commands
    class Upload < Ckancli::Command
      def initialize(options)
        @options = options

        @dir = nil
        @resources = []
        @http_resource = false
        @schema = nil
        @resource_config = nil
        @dataset_config = nil
        @api_config = nil
        @logger = nil
        @ckan_client = nil
        @update_modified = false
        @mail_server = nil
      end

      def execute(input: $stdin, output: $stdout)
        begin
          prepare_options(@options)

          if !@schema.nil?
            validate()
          else 
            puts ""
            show_info "No schema - skipping validation"
          end

          upload()

          if !@dataset_config.nil?
            update_dataset()
          else 
            puts ""
            show_info "No dataset configuration - skipping update"
          end

          @resources.each do |res|
            if !res[:log_file].nil?
              res[:log_file].close
            end
          end

          if !@mail_server.nil? && !@mail_receivers.nil?
            mail_notify()
          end
        rescue StandardError => e
          return_error "Unexpected error", e
        end
      end

      private
        def prepare_options(options)
          @http_resource = true if options[:dir] =~ /^http(s)?/

          if @http_resource
            @dir = Dir.pwd
          else
            @dir = File.directory?(options[:dir]) ? options[:dir] : (File.file?(options[:dir]) ? File.dirname(options[:dir]) : nil)
          end
          
          if @dir.nil?
            return_error "Invalid directory - #{options[:dir]}"
          end

          begin
            @logger = TTY::Logger.new do |config|
              config.metadata = [:date, :time]
              config.handlers = [
                [:stream, output: File.open(File.join(@dir, "output.log"), "a")]
              ]
            end
          rescue StandartError => e
            return_error "Could not initialize logger", e 
          end

          begin
            if @http_resource
              file_path = File.join(@dir, File.basename(URI.parse(options[:dir]).path))

              File.open(file_path, "wb") do |file|
                file.write open(options[:dir]).read
              end

              @resources.push(file_path)
            else
              if File.directory?(options[:dir])
                @resources = Dir.entries(options[:dir]).select{ |f| File.file?(File.join(options[:dir], f)) && (options[:ignoreextension] || File.extname(f).downcase == ".csv") }.map { |f| File.join(options[:dir], f) }
              else
                @resources.push(options[:dir])
              end
            end

            @resources = @resources.map{ |r| 
              { 
                :path => r,
                :valid => true, 
                :summary => nil, 
                :log_file => File.open(File.join(@dir, "#{File.basename(r)}.log"), "w"), 
                :log => nil 
              } 
            }

            @resources.each do |res|
              res[:log] = TTY::Logger.new do |config|
                config.metadata = [:date, :time]
                config.handlers = [
                  [:stream, output: res[:log_file]]
                ]
              end
            end
          rescue Errno::ENOENT => e
            return_error "Could not load resources", e
          rescue StandardError => e
            return_error "Could not load resources", e
          end

          if options[:validationschema]
            @schema = (Pathname.new(options[:validationschema])).absolute? ? options[:validationschema] : File.join(@dir, options[:validationschema])
          end

          if options[:resourceconfig]
            begin
              @resource_config = JSON.parse(File.read((Pathname.new(options[:resourceconfig])).absolute? ? options[:resourceconfig] : File.join(@dir, options[:resourceconfig])))
            rescue Errno::ENOENT => e
              return_error "Could not load resource configuration", e
            end
          end

          if options[:datasetconfig]
            begin
              @dataset_config = JSON.parse(File.read((Pathname.new(options[:datasetconfig])).absolute? ? options[:datasetconfig] : File.join(@dir, options[:datasetconfig])))
            rescue Errno::ENOENT => e
              return_error "Could not load dataset configuration", e
            end
          end

          if options[:configuration]
            begin
              @api_config = JSON.parse(File.read((Pathname.new(options[:configuration])).absolute? ? options[:configuration] : File.join(@dir, options[:configuration])))
            rescue Errno::ENOENT => e
              return_error "Could not load configuration", e
            end
          end

          if !@api_config.nil?
            @ckan_client = CkanClient::Client.new(@api_config["ckan_api"]["url"], @api_config["ckan_api"]["api_key"])
            @mail_server = @api_config["email_server"]
            @mail_receivers = @api_config["notification_receiver"]
          end

          @update_modified = options[:updatemodified]
          @overwrite = options[:overwrite]
        end

        def validate()
          puts ""
          show_info "Starting validations..."
          @resources.each do |res|
            task("Validating resource: #{File.basename(res[:path])}") do
              ok = false
              msg = nil
              exception = nil

              begin
                res[:log].info "Validating resource..."

                res[:valid] = false

                source = read_resource(res[:path])
                schema = read_schema(@schema)

                if schema.class == Csvlint::Schema && schema.description == "malformed"
                  msg = "Invalid schema - malformed JSON"
                else
                  validator = Csvlint::Validator.new(source, {}, schema)

                  if validator.errors.length > 0 || validator.warnings.length > 0
                    msg = "#{validator.errors.length} errors, #{validator.warnings.length} warnings"
                    res[:summary] = {
                      :errors => validator.errors.map { |v| format_validation(v, schema) },
                      :warnings => validator.warnings.map { |v| format_validation(v, schema) }
                    }

                    res[:log].error res[:summary].to_json
                  end

                  ok = validator.valid?
                  res[:valid] = ok
                end
              rescue Errno::ENOENT, OpenURI::HTTPError => e
                msg = "Could not load file - #{e.message}"
              rescue Csvlint::Csvw::MetadataError => e
                msg = "Invalid schema metadata - #{e.message}"
              rescue StandardError => e
                msg = "Could not validate resource"
                exception = e
              end

              if !exception.nil?
                res[:log].error msg, exception
              elsif !msg.nil?
                res[:log].info msg
              else 
                res[:log].info "OK - Validation successfull"
              end
              res[:log].info "End of validation"

              [ok, msg, exception]
            end
          end

          show_info "End of validations"
        end

        def mail_notify
          puts ""
          show_info "Sending e-mail notifications..."

          begin
            mail = Mail.new
            mail[:from] = @mail_server["sender"]
            mail[:to] = @mail_receivers["error"]
            mail[:subject] = @mail_server["subject"]
            mail.delivery_method :smtp, { 
              :address              => @mail_server["address"],
              :port                 => @mail_server["port"],
              :user_name            => @mail_server["smtp_user"],
              :password             => @mail_server["smtp_password"],
              :authentication       => @mail_server["smtp_user"].nil? ? "none" : "plain",
              :ssl                  => @mail_server["ssl"],
              :openssl_verify_mode  => OpenSSL::SSL::VERIFY_NONE  
            }
  
            # message
            msg = "CKAN CLI task completed.\r\n\r\n#{@resources.length} files processed"

            # attachments
            @resources.each do |res|
              msg = "#{msg}\r\n-  #{File.basename(res[:path])}"
              if !res[:summary].nil?
                msg = "#{msg} (#{res[:summary][:errors].length} errors, #{res[:summary][:warnings].length} warnings)"
              end
              mail.add_file :filename => File.basename(res[:path] + ".log"), :content => File.read(res[:path] + ".log")
            end
            msg = "#{msg}\r\n\r\nLog files attached."
            mail[:body] = msg

            mail.deliver!
          rescue StandardError => e
            show_error "Could not send e-mail", e
          end

          show_info "End of sending"
        end

        def upload()
          puts ""
          show_info "Starting upload..."
          @resources.each do |res|
            next unless res[:valid]

            task("Uploading resource: #{File.basename(res[:path])}") do
              res[:log].info "Uploading resource..."

              ok = true
              msg = nil
              exception = nil

              params = @resource_config["result"].clone

              if @update_modified
                params["last_modified"] = JSON.parse(Time.new.to_json)
              end

              # check if resource exists and if overwriting
              if !params["id"].nil? && !@overwrite 
                resource = @ckan_client.get_resource(params["id"])

                if !resource.nil?
                  ok = false
                  msg = "Resource already exists - skipping. Use parameter 'overwrite' to overwrite changes."
                end
              end

              if ok
                @ckan_client.create_or_update_resource(params, File.new(res[:path], 'rb'), true){ |response, status_ok| 
                  ok = status_ok
  
                  if !ok
                    msg = "HTTP error #{response.code}"
  
                    log_error response.body
                  end
                }
              end

              if !ok
                res[:log].error msg
              else
                res[:log].info "OK - upload successfull"
              end
              res[:log].info "End of upload"

              [ok, msg, exception]
            end
          end

          show_info "End of upload"
        end

        def update_dataset()
          puts ""
          show_info "Starting dataset update..."

          task("Updating dataset") do
            ok = false
            msg = nil
            exception = nil

            @ckan_client.update_package(@dataset_config["result"]["id"], @dataset_config["result"].clone, true){ |response, status_ok| 
              ok = status_ok

              if !ok
                msg = "HTTP error #{response.code}"

                log_error response.body
              end
            }

            [ok, msg, exception]
          end
          show_info "End of dataset update"
        end

        def return_error(message, exception = nil)
          show_error(message, exception)

          exit 1
        end

        def show_error(message, exception = nil)
          if !exception.nil?
            message = "#{message} - #{exception.message}"
          end
          
          puts "  #{message}  ".white.on_red
          
          log_fatal message, exception
        end

        def show_info(message)
          puts " #{message} "

          log_info message
        end

        def task(message)
          log_info message

          spinner = TTY::Spinner.new("[:spinner] #{message}...")
          spinner.auto_spin
          ok, message, exception = yield
          spinner.stop(ok ? "OK".green : "ERROR".red)

          if !message.nil?
            message = "    #{message}"

            if !exception.nil?
              show_error message, exception
            else 
              show_info message
            end
          end
        end

        def read_resource(source)
          # check if URL or file
          unless source =~ /^http(s)?/
            source = File.new( source )
          end

          source
        end

        def read_schema(path)
          schema = Csvlint::Schema.load_from_uri(path, false)
    
          schema
        end

        def format_validation(error, schema = nil)
          h = {
            type: error.type,
            category: error.category,
            row: error.row,
            col: error.column
          }
  
          if error.column && !schema.nil? && schema.class == Csvlint::Schema && schema.fields[error.column - 1] != nil
            field = schema.fields[error.column - 1]
            h[:header] = field.name
          end
  
          h
        end

        def log_fatal(message, exception = nil)
          if !@logger.nil? 
            @logger.fatal message, exception
          end
        end

        def log_info(message)
          if !@logger.nil? 
            @logger.info message
          end
        end

        def log_error(message)
          if !@logger.nil? 
            @logger.error message
          end
        end
    end
  end
end