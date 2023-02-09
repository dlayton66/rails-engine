require 'rails_helper'

RSpec.describe 'get item merchant' do
  it 'can get merchant for an item' do
    item = create(:item)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_a(Hash)

    merchant = json_response[:data]

    expect(merchant).to be_a(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(item.merchant.id.to_s)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq(item.merchant.name)
  end

  it 'returns error if item not found' do
    get "/api/v1/items/-1/merchant"

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Couldn't find Item with 'id'=-1")
  end
end