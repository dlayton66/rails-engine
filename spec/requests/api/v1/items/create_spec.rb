require 'rails_helper'

RSpec.describe 'create item' do
  let(:merchant_id) { create(:merchant).id }
  let(:item_params) {{
                      name: "Sunglasses",
                      description: "Make you look cool",
                      unit_price: 10.95,
                      merchant_id: merchant_id
                    }}
  let(:headers) {{"CONTENT_TYPE" => "application/json"}}

  it 'can create an item' do
    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id]) 
  end

  it 'returns a JSON response' do
    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_a(Hash)

    item = json_response[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(Item.last.id.to_s)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq("item")

    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)
    
    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'returns an error if attribute is missing' do
    error_params = {
                    name: "Sunglasses",
                    description: "Make you look cool"
                   }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: error_params)

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors]).to include("Merchant must exist", "Unit price can't be blank")
  end

  it 'ignores unsupported attributes' do
    extra_params = {
                    name: "Sunglasses",
                    description: "Make you look cool",
                    unit_price: 10.95,
                    merchant_id: merchant_id,
                    size: "BIG"
                   }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: extra_params)
    
    # test response
    
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)
    item = json_response[:data]
    
    expect(item[:attributes][:size]).to be(nil)

    # test database entry

    item = Item.last

    expect(item.attributes["size"]).to be(nil)
  end
end