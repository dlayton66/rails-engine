require 'rails_helper'

RSpec.describe 'update an item' do
  it 'can update an item' do
    item_id = create(:item, name: "Chapstick").id
    previous_name = Item.last.name
    item_params = { name: "Speakers" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find(item_id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Speakers")
  end

  it 'throws error if merchant id does not exist' do
    item_id = create(:item).id
    item_params = { merchant_id: 999999999999 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate(item: item_params)
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Merchant must exist")
  end
end