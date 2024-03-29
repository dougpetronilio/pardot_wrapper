module Pardot
  class Client
    include HTTParty

    BASE_URIS = {
      production: 'https://pi.pardot.com/api/v5/objects',
      demo: 'https://pi.demo.pardot.com/api/v5/objects',
      login: 'https://login.salesforce.com'
    }
    LIST_CUSTOM_FIELDS = "id,name,fieldId,updatedAt,type,isRecordMultipleResponses,salesforceId,isUseValues,isRequired"

    attr_reader :token_refreshed, :access_token

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

    def list_custom_fields(fields=LIST_CUSTOM_FIELDS)
      perform_request { self.class.get("/custom-fields?fields=#{fields}", headers: auth_headers) }
    end

    def get_account
      perform_request { self.class.get('/account?fields=id,company,website', headers: auth_headers) }
    end

    def create_prospect(email, params = {})
      query = params.merge(email: email)
      perform_request { self.class.post('/prospects', body: query.to_json, headers: auth_headers) }
    end

    def add_prospect_to_list_membership(prospect_id, list_id, opted_out)
      query = { prospectId: prospect_id, listId: list_id, optedOut: opted_out }
      perform_request { self.class.post('/list-memberships?fields=id', body: query.to_json, headers: auth_headers) }
    end

    def get_prospect_by_email(email, fields='id, createdAt', order_by='createdAt desc')
      perform_request { self.class.get("/prospects?fields=#{fields}&email=#{email}&orderBy=#{order_by}", headers: auth_headers) }
    end

    def update_prospect(prospect_id, params = {})
      query = params
      perform_request { self.class.patch("/prospects/#{prospect_id}", body: query.to_json, headers: auth_headers) }
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
        @token_refreshed = true
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

      response
    end
  end
end
