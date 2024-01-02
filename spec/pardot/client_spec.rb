# spec/pardot/client_spec.rb

require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

RSpec.describe Pardot::Client do
  let(:client) { Pardot::Client.new('access_token', 'refresh_token', 'client_id', 'client_secret', 'business_unit_id', :production) }
  let(:authorization) do
    {
      "Authorization" => "Bearer access_token",
      "Pardot-Business-Unit-Id" => "business_unit_id"
    }
  end

  before do
    stub_request(:any, /pardot.com/).to_return(body: 'stubbed response', status: 200)
    stub_request(:any, /salesforce.com/).to_return(body: 'stubbed response', status: 200)
  end

  describe "#list_custom_fields" do
    it "makes a GET request to the custom fields endpoint" do
      client.list_custom_fields
      expect(WebMock).to have_requested(:get, "https://pi.pardot.com/api/v5/objects/custom-fields?fields=id,name,fieldId,updatedAt,type,isRecordMultipleResponses,salesforceId,isUseValues,isRequired")
        .with(headers: authorization)
    end
  end

  describe "#get_account" do
    it "makes a GET request to the account endpoint" do
      client.get_account
      expect(WebMock).to have_requested(:get, "https://pi.pardot.com/api/v5/objects/account?fields=id,company,website")
        .with(headers: authorization)
    end
  end

  describe "#create_prospect" do
    it "makes a POST request to create a prospect" do
      client.create_prospect("email@example.com", { param1: 'value1' })
      expect(WebMock).to have_requested(:post, "https://pi.pardot.com/api/v5/objects/prospects")
        .with(body: hash_including({ email: "email@example.com", param1: 'value1' }))
    end
  end

  describe "#create_list_membership" do
    it "makes a POST request to create a list membership" do
      client.add_prospect_to_list_membership(123, 456)
      expect(WebMock).to have_requested(:post, "https://pi.pardot.com/api/v5/objects/list-memberships")
        .with(body: hash_including({ prospectId: 123, listId: 456 }))
    end
  end

  describe "#refresh_access_token" do
    context "when the access token is expired" do
      before do
        stub_request(:get, "https://pi.pardot.com/api/v5/objects/account?fields=id,company,website")
          .to_return({status: 401, body: "Access token expired"},
                     { status: 200, body: "Sucesso" })

        stub_request(:post, "https://login.salesforce.com/services/oauth2/token")
          .to_return(
            status: 200,
            body: { access_token: 'new_access_token' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "refreshes the access token" do
        client.get_account
        expect(client.instance_variable_get(:@access_token)).to eq('new_access_token')
      end
    end
  end
end
