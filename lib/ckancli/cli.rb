# frozen_string_literal: true

require 'thor'

module Ckancli
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    class_option :dir, type: :string, required: true, desc: 'Path to CSV files. Full path to directory or URL.', aliases: '-d'
    class_option :resourceconfig, type: :string, required: true, desc: 'CKAN resource metadata file (JSON). Absolute or relative path.', aliases: '-r'
    class_option :configuration, type: :string, required: true, desc: 'Global configuration file (JSON). Absolute or relative path.', aliases: '-c'
    class_option :validationschema, type: :string, required: false, desc: 'Validation schema (JSON). Absolute or relative path.', aliases: '-v'
    class_option :datasetconfig, type: :string, required: false, desc: 'CKAN dataset metadata file (JSON). Absolute or relative path.', aliases: '-p'
    class_option :updatemodified, type: :boolean, required: false, desc: 'Update modified date of resource.', aliases: '-m'
    class_option :ignoreextension, type: :boolean, require: false, desc: 'Ignore file extensions (process all files not only CSV).', aliases: '-i'
    class_option :overwrite, type: :boolean, require: false, desc: 'Overwrite resource if existing is found by identifier.', aliases: '-w'

    # Error raised by this runner
    Error = Class.new(StandardError)

    # desc 'version', 'CKAN CLI version'
    # def version
    #  require_relative 'version'
    #  puts "v#{Ckancli::VERSION}"
    # end
    # map %w(--version -v) => :version

    desc 'upload', 'Processes CSV files and uploads to CKAN API. '
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def upload(*)
      if options[:help]
        invoke :help, ['upload']
      else
        require_relative 'commands/upload'
        Ckancli::Commands::Upload.new(options).execute
      end
    end
    default_task :help
  end
end
