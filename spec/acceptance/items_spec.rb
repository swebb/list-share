require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource "List" do
  let(:user) { FactoryGirl.create :user }
  let(:list) { List.create_for user, with: { name: "Groceries" } }
  let(:item) do
    Item.create({
      list: list,
      name: "Apples",
      completed: false,
      starred: false,
      priority: 0,
      due_date: Date.today,
      notes: "Tasty"
    })
  end
  let(:id) { item.id }

  patch "/items/:id" do
    parameter :name, "Name of the item", required: false, scope: :item
    parameter :completed, "Has the item been completed?", required: false, scope: :item
    parameter :starred, "Is the item starred?", required: false, scope: :item
    parameter :priority, "Priority of the item", required: false, scope: :item
    parameter :due_date, "When is the item due", required: false, scope: :item
    parameter :notes, "Additional notes about the item", required: false, scope: :item

    let(:name) { "Green Apples" }
    let(:completed) { true }
    let(:starred) { true }
    let(:priority) { 1 }
    let(:due_date) { Date.tomorrow }
    let(:notes) { "For pie" }

    let(:expected_response) do
      a_hash_including({
        "id" => item.id,
        "name" => "Green Apples",
        "completed" => true,
        "starred" => true,
        "priority" => 1,
        "due_date" => Date.tomorrow.to_s,
        "notes" => "For pie"
      })
    end

    example "Updating an item" do
      do_request

      expect(status).to eq 200

      expect(JSON.parse(response_body)).to match expected_response
    end
  end

  delete "/items/:id" do
    let(:expected_response) do
      a_hash_including({
        "id" => item.id,
        "name" => "Apples",
        "completed" => false,
        "starred" => false,
        "priority" => 0,
        "due_date" => Date.today.to_s,
        "notes" => "Tasty"
      })
    end

    example "Deleting an item" do
      do_request

      expect(status).to eq 200

      expect(JSON.parse(response_body)).to match expected_response
      expect(Item.exists? item.id).to eq false
    end
  end
end
