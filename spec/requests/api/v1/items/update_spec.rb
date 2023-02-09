require 'rails_helper'

RSpec.describe 'update an item' do
  let(:headers) { {"CONTENT_TYPE" => "application/json"} }

  it 'can update an item' do
    item_id = create(:item, name: "Chapstick").id
    previous_name = Item.last.name
    item_params = { name: "Speakers" }

    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find(item_id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Speakers")
  end

  it 'returns error if merchant id does not exist' do
    item_id = create(:item).id
    item_params = { merchant_id: -1 }

    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate(item: item_params)
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Merchant must exist")
  end

  it 'returns error if item not found' do
    item_params = { name: "Speakers" }

    patch "/api/v1/items/-1", headers: headers, params: JSON.generate(item: item_params)
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Couldn't find Item with 'id'=-1")
  end
end