# frozen_string_literal: true

require 'json'
require 'rest-client'

module CkanClient
  class Client
    def initialize(url, key)
      raise ArgumentError, "No URL provided" unless !url.nil?
      raise ArgumentError, "No API KEY provided" unless !key.nil?

      # remove trailig slashes
      @url = url.sub(/(\/)+$/,"")
      @key = key
      @headers = {}
      @headers[:Authorization] = @key
    end

    def get_resource(id, params = {}, &block)
      raise ArgumentError, "No ID provided for resource" unless !id.nil?

      result = nil
      params["id"] = id

      post("resource_show", params, nil){ |response, status_ok|
        if status_ok
          result = JSON.parse(response.body)["result"]
        end
      }

      return result
    end

    def create_resource(params = {}, file = nil, &block)
      if params["name"].nil? && !file.nil?
        params["name"] = File.basename(file.path)
      end

      post("resource_create", params, file, &block)
    end

    def update_resource(id, params = {}, file = nil, resolve_delta = false, &block)
      raise ArgumentError, "No ID provided for resource update" unless !id.nil?

      params["id"] = id

      if resolve_delta
        metadata = get_resource(id)
        if !metadata.nil?
          params = metadata.merge(params)
        end
      end

      post("resource_update", params, file, &block)
    end

    def create_or_update_resource(params = {}, file = nil, resolve_delta = false, &block)
      if params["id"].nil?
        create_resource(params, file, &block)
      else 
        update_resource(params["id"], params, file, resolve_delta, &block)
      end
    end

    def get_package(id, params = {}, &block)
      raise ArgumentError, "No ID provided for package" unless !id.nil?

      result = nil
      params["id"] = id

      post("package_show", params, nil){ |response, status_ok|
        if status_ok
          result = JSON.parse(response.body)["result"]
        end
      }

      return result
    end

    def create_package(params = {}, &block)
      post("package_create", params, nil, &block)
    end

    def update_package(id, params = {}, resolve_delta = false, &block)
      raise ArgumentError, "No ID provided for package update" unless !id.nil?

      params["id"] = id

      if resolve_delta
        metadata = get_package(id)
        if !metadata.nil?
          params = metadata.merge(params)
        end
      end

      post("package_update", params, nil, &block)
    end

    def create_or_update_package(params = {}, resolve_delta = false, &block)
      if params["id"].nil?
        create_package(params, &block)
      else 
        update_package(params["id"], params, resolve_delta, &block)
      end
    end

    private
      def post(action, params = {}, file = nil, &block)
        raise ArgumentError, "No action provided" unless !action.nil?

        payload = {}
        if !file.nil?
          payload[:upload] = file
        end
        payload = payload.merge(params)

        if file.nil?
          payload = payload.to_json
          @headers[:content_type] = :json
        else
          @headers.delete(:content_type)
        end
        RestClient::Request.execute(
          method: :post,
          url: "#{@url}/action/#{action}",
          payload: payload,
          headers: @headers,
          timeout: 360,       # Timeout in seconds for the operation to complete
          open_timeout: 60,   # Timeout in seconds to wait for the connection to open
        ){ |response, request, result|
          block.call(response, response.code == 200)
        }

#        RestClient.post("#{@url}/action/#{action}", payload, @headers){ |response, request, result|
#          block.call(response, response.code == 200)
#        }
      end
    end
end
