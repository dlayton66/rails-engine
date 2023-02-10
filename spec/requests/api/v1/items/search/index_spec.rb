require 'rails_helper'

RSpec.describe 'find all items' do
  describe 'happy path' do
    let!(:database_items) {create_list(:item, 100)}

    it 'finds all items by name' do
      get '/api/v1/items/find_all?name=t'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_an(Array)
  
      items = json_response[:data]
    
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
  
        expect(item).to have_key(:type)
        expect(item[:type]).to eq("item")
  
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
  
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name].downcase).to include("t")
  
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
  
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
  
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'finds all items by min price' do
      get '/api/v1/items/find_all?min_price=30'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_an(Array)
  
      items = json_response[:data]
    
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
        expect(item[:attributes][:unit_price]).to be >= 30
  
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'finds all items by max price' do
      get '/api/v1/items/find_all?max_price=70'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_an(Array)
  
      items = json_response[:data]
    
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
        expect(item[:attributes][:unit_price]).to be <= 70
  
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'finds all items by min and max price' do
      get '/api/v1/items/find_all?min_price=30&max_price=70'

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_an(Array)
  
      items = json_response[:data]
    
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
        expect(item[:attributes][:unit_price]).to be_between(30,70)
  
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end

  describe 'errors' do
    it 'returns error if price is negative' do
      get '/api/v1/items/find_all?min_price=-1'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Price cannot be negative")

      get '/api/v1/items/find_all?max_price=-1'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Price cannot be negative")
    end
    
    it 'returns error if no match' do
      create_list(:item, 3)
  
      get '/api/v1/items/find_all?name=THERESNOWAYTHISISINFAKER'
  
      expect(response.status).to eq(400)
  
      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_a(Hash)
  
      item = json_response[:data]
  
      expect(item).to be_a(Hash)
  
      expect(item).to have_key(:id)
      expect(item[:id]).to be(nil)
  
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
  
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to be_empty
    end

    it 'returns error if parameters are missing' do
      get '/api/v1/items/find_all'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Parameters cannot be missing")
    end

    it 'returns error if parameters are empty' do
      get '/api/v1/items/find_all?name='
  
      expect(response.status).to eq(400)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")
  
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
  
      expect(error_response[:errors][0]).to eq("Parameters cannot be empty")
    end

    it 'returns error if only unsupported parameter is passed' do
      get '/api/v1/items/find_all?description=big'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Invalid parameter passed. Valid parameters: name, min_price, max_price")
    end

    it 'returns error if any unsupported parameter is passed' do
      get '/api/v1/items/find_all?name=ring&description=big'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Invalid parameter passed. Valid parameters: name, min_price, max_price")
    end

    it 'returns error if supported parameters are mixed' do
      get '/api/v1/items/find_all?name=ring&max_price=70'

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors][0]).to eq("Cannot mix name and price parameters")
    end
  end
end