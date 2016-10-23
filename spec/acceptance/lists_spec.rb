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
    post "/lists/:list_id/items" do
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

  resource "Collaborators" do
    let(:list) { List.create_for user, with: { name: "Groceries" } }
    let(:list_id) { list.id }

    post "/lists/:list_id/collaborators" do
      parameter :id, "ID or email of the collaborator to add", required: true, scope: :list

      let(:id) { nil }
      let(:collaborator) { FactoryGirl.create :user }

      let(:expected_response) { { "result" => "success" } }

      example "Adding a collaborator by id" do
        do_request(id: collaborator.id)

        expect(status).to eq 201

        expect(JSON.parse(response_body)).to match expected_response
        expect(Membership.where(user_id: collaborator.id, list_id: list.id)).to exist
      end

      example "Adding a collaborator by email" do
        do_request(id: collaborator.email)

        expect(status).to eq 201

        expect(JSON.parse(response_body)).to match expected_response
        expect(Membership.where(user_id: collaborator.id, list_id: list.id)).to exist
      end
    end

    delete "/lists/:list_id/collaborators/:id" do
      parameter :id, "ID of the collaborator to remove", required: true, scope: :list

      let(:id) { collaborator.id }
      let(:collaborator) { FactoryGirl.create(:membership, list: list).user }
      let!(:item) { Item.create name: "Apples", list: list, user: collaborator }

      let(:expected_response) { { "result" => "success" } }

      example "Removing a collaborator" do
        do_request

        expect(status).to eq 200

        expect(JSON.parse(response_body)).to match expected_response
        expect(Membership.where(user_id: collaborator.id, list_id: list.id)).to_not exist
        expect(item.reload.user).to eq nil
      end
    end
  end
end
