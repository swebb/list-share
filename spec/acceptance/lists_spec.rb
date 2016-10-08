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

    example "Creating a list" do
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

    example "Updating a list" do
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

    example "Deleting a list with no other members" do
      do_request

      expect(status).to eq 200

      expect(List.where(id: list.id)).to_not exist
      expect(Membership.where(list_id: list.id)).to_not exist
    end

    example "Deleting a membership for a list with other members" do
      FactoryGirl.create(:user).memberships.create list: list

      do_request

      expect(status).to eq 200

      expect(List.where(id: list.id)).to exist
      expect(Membership.where(user_id: user.id, list_id: list.id)).to_not exist
    end
  end

  resource "Item" do
    parameter :name, "Name of the item", required: true, scope: :item
    parameter :completed, "Has the item been completed?", required: false, scope: :item
    parameter :starred, "Is the item starred?", required: false, scope: :item
    parameter :priority, "Priority of the item", required: false, scope: :item
    parameter :due_date, "When is the item due", required: false, scope: :item
    parameter :notes, "Additional notes about the item", required: false, scope: :item

    let(:list) { List.create_for user, with: { name: "Groceries" } }
    let(:list_id) { list.id }
    let(:name) { "Milk" }
    let(:completed) { false }
    let(:starred) { false }
    let(:priority) { 1 }
    let(:due_date) { Date.today }
    let(:notes) { "For my tea" }
    let(:expected_response) do
      a_hash_including({
        "id" => Integer,
        "name" => "Milk",
        "completed" => false,
        "starred" => false,
        "priority" => 1,
        "due_date" => Date.today.to_s,
        "notes" => "For my tea"
      })
    end

    post "/lists/:list_id/items" do
      example "Creating an item" do
        do_request

        expect(status).to eq 201
        expect(JSON.parse(response_body)).to match expected_response

        list.reload
        expect(list.items.count).to eq 1
        expect(list.items.first.name).to eq name
      end
    end
  end
end
