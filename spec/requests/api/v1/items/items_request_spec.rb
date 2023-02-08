require 'rails_helper'

RSpec.describe 'Items API' do
  it 'can get all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

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

  end

  it 'can get one item' do
    item_id = create(:item).id

    get "/api/v1/items/#{item_id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to be_a(Hash)

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(item_id.to_s)

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

  it 'can create an item' do
    merchant_id = create(:merchant).id
    item_params = {
                    name: "Sunglasses",
                    description: "Make you look cool",
                    unit_price: 10.95,
                    merchant_id: merchant_id
                  }
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id]) 
  end

  it 'can destroy an item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'update' do
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
end