module Pardot
  class Client
    include HTTParty

    BASE_URIS = {
      production: 'https://pi.pardot.com/api/v5/objects',
      demo: 'https://pi.demo.pardot.com/api/v5/objects',
      login: 'https://login.salesforce.com'
    }

    def initialize(access_token, refresh_token, client_id, client_secret, pardot_business_unit_id, environment = :production)
      @access_token = access_token
      @refresh_token = refresh_token
      @client_id = client_id
      @client_secret = client_secret
      @pardot_business_unit_id = pardot_business_unit_id
      @token_refreshed = false
      @environment = environment

      self.class.base_uri BASE_URIS[environment]
    end

    def list_custom_fields
      perform_request { self.class.get('/custom-fields', headers: auth_headers) }
    end

    def get_account
      perform_request { self.class.get('/account?fields=id,company,website', headers: auth_headers) }
    end

    def create_prospect(email, params = {})
      query = params.merge({ email: email })
      perform_request { self.class.post('/prospects', body: query.to_json, headers: auth_headers) }
    end

    def create_list_membership(prospect_id, list_id)
      query = { prospect_id: prospect_id, list_id: list_id }
      perform_request { self.class.post('/list-memberships', body: query.to_json, headers: auth_headers) }
    end

    private

    def auth_headers
      {
        "Authorization" => "Bearer #{@access_token}",
        "Pardot-Business-Unit-Id" => @pardot_business_unit_id,
        "Content-Type" => "application/json"
      }
    end

    def refresh_access_token
      self.class.base_uri BASE_URIS[:login]

      response = self.class.post('/services/oauth2/token', {
        body: {
          grant_type: 'refresh_token',
          refresh_token: @refresh_token,
          client_id: @client_id,
          client_secret: @client_secret
        }
      })

      self.class.base_uri BASE_URIS[@environment]

      if response.success?
        @access_token = response['access_token']
        @token_refreshed = false
      else
        raise "Failed to refresh access token: #{response.body}"
      end
    end

    def perform_request
      response = yield

      if response.code == 401
        refresh_access_token
        response = yield
      end

      raise "API request failed: #{response.body}" unless response.success?

      response
    end
  end
end
