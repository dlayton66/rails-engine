require 'rails_helper'

RSpec.describe 'get merchant items' do
  it 'can get all items from a merchant by id' do
    merchant_id = create(:merchant).id
    merchant_items = create_list(:item, 3, merchant_id: merchant_id)
    other_merchant_item_id = create(:item).id

    get "/api/v1/merchants/#{merchant_id}/items"

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)

    items = json_response[:data]

    items.each.with_index do |item, i|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:id]).to eq(merchant_items[i].id.to_s)
      expect(item[:id]).to_not eq(other_merchant_item_id.to_s)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to eq(merchant_items[i].name)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:description]).to eq(merchant_items[i].description)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to eq(merchant_items[i].unit_price)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant_id)
    end
  end

  it 'returns error if merchant not found' do
    get "/api/v1/merchants/-1/items"

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Couldn't find Merchant with 'id'=-1")
  end
end