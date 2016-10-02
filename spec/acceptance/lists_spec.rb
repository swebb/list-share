require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource "List" do
  let!(:user) { FactoryGirl.create :user }

  post "/lists" do
    parameter :name, "Name of the list", required: true, scope: :list

    let(:name) { "Groceries" }
    let(:expected_response) do
      a_hash_including({
        "id" => Integer,
        "name" => "Groceries"
      })
    end

    example "Successfully creating a list" do
      do_request

      expect(status).to eq 201

      expect(JSON.parse(response_body)).to match expected_response
    end
  end

  patch "/lists/:id" do
    parameter :name, "Name of the list", required: false, scope: :list

    let(:list) { List.create_for user, with: { name: "Shopping" } }
    let(:id) { list.id }
    let(:name) { "Groceries" }
    let(:expected_response) do
      a_hash_including({
        "id" => list.id,
        "name" => "Groceries"
      })
    end

    example "Successfully updating a list" do
      do_request

      expect(status).to eq 200

      expect(JSON.parse(response_body)).to match expected_response
    end
  end

  delete "/lists/:id" do
    let(:list) { List.create_for user, with: { name: "Groceries" } }
    let(:id) { list.id }
    let(:expected_response) do
      a_hash_including({
        "id" => list.id,
        "name" => "Groceries"
      })
    end

    example "Successfully deleting a list with no other memberships" do
      do_request

      expect(status).to eq 200

      expect(List.where(id: list.id)).to_not exist
      expect(Membership.where(list_id: list.id)).to_not exist
    end

    example "Successfully deleting a membership for a list with other memberships" do
      FactoryGirl.create(:user).memberships.create list: list

      do_request

      expect(status).to eq 200

      expect(List.where(id: list.id)).to exist
      expect(Membership.where(user_id: user.id, list_id: list.id)).to_not exist
    end
  end
end
