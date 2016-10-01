require 'spec_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource "List" do
  post "/lists" do
    parameter :name, "Name of the list", required: true, scope: :list

    let(:name) { "Groceries" }
    let(:expected_response) do
      a_hash_including({
        "id" => Integer,
        "name" => "Groceries"
      })
    end

    before { FactoryGirl.create :user }

    example "Successfully creating a list" do
      do_request

      expect(status).to eq 201

      expect(JSON.parse(response_body)).to match expected_response
    end
  end
end
