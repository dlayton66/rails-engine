require 'rails_helper'

RSpec.describe 'get all items' do
  it 'can get all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)

    items = json_response[:data]

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

  it 'still returns array of data for 0 or 1 items' do
    get '/api/v1/items'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)

    create(:item)

    get '/api/v1/items'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)
  end

  describe 'pagination' do
    let!(:database_items) { create_list(:item, 100) }

    it 'returns 20 items per page by default' do
      get '/api/v1/items'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      expect(items.count).to eq(20)
    end

    it 'returns the first page by default' do
      get '/api/v1/items'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      items.each.with_index do |item, i|
        expect(item[:id]).to eq(database_items[i].id.to_s)
        expect(item[:attributes][:name]).to eq(database_items[i].name)
        expect(item[:attributes][:description]).to eq(database_items[i].description)
        expect(item[:attributes][:unit_price]).to eq(database_items[i].unit_price)
        expect(item[:attributes][:merchant_id]).to eq(database_items[i].merchant_id)
      end
    end

    it 'allows user to specify a page' do
      get '/api/v1/items?page=2'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      items.each.with_index do |item, i|
        expect(item[:id]).to eq(database_items[i+20].id.to_s)
        expect(item[:attributes][:name]).to eq(database_items[i+20].name)
        expect(item[:attributes][:description]).to eq(database_items[i+20].description)
        expect(item[:attributes][:unit_price]).to eq(database_items[i+20].unit_price)
        expect(item[:attributes][:merchant_id]).to eq(database_items[i+20].merchant_id)
      end
    end

    it 'allows user to specify items per page' do
      get '/api/v1/items?per_page=15'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      expect(items.count).to eq(15)
    end

    it 'allows user to specify a page and items per page' do
      get '/api/v1/items?page=3&per_page=15'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
      items = json_response[:data]

      items.each.with_index do |item, i|
        expect(item[:id]).to eq(database_items[i+30].id.to_s)
        expect(item[:attributes][:name]).to eq(database_items[i+30].name)
        expect(item[:attributes][:description]).to eq(database_items[i+30].description)
        expect(item[:attributes][:unit_price]).to eq(database_items[i+30].unit_price)
        expect(item[:attributes][:merchant_id]).to eq(database_items[i+30].merchant_id)
      end
    end
  end
end