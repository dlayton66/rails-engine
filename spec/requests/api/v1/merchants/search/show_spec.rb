require 'rails_helper'

RSpec.describe 'find merchant' do
  it 'finds a single merchant' do
    create_list(:merchant, 3)
    create(:merchant, name: "Mart")
    merchant_id = create(:merchant, name: "AAA Mart").id

    get '/api/v1/merchants/find?name=mart'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_a(Hash)

    merchant = json_response[:data]

    expect(merchant).to be_a(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(merchant_id.to_s)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq("AAA Mart")
  end

  
  describe 'errors' do
    it 'returns error if no match' do
      create_list(:merchant, 3)
  
      get '/api/v1/merchants/find?name=THERESNOWAYTHISISINFAKER'
  
      expect(response.status).to eq(400)
  
      json_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to be_a(Hash)
  
      merchant = json_response[:data]
  
      expect(merchant).to be_a(Hash)
  
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be(nil)
  
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")
  
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to be_empty
    end
    
    it 'returns error if parameters are missing' do
      get '/api/v1/merchants/find'
  
      expect(response.status).to eq(400)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")
  
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
  
      expect(error_response[:errors][0]).to eq("Parameters cannot be missing")
    end

    it 'returns error if parameters are empty' do
      get '/api/v1/merchants/find?name='
  
      expect(response.status).to eq(400)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")
  
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
  
      expect(error_response[:errors][0]).to eq("Parameters cannot be empty")
    end

    it 'returns error if only invalid parameter is passed' do
      get '/api/v1/merchants/find?min_price=50'
  
      expect(response.status).to eq(400)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")
  
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
  
      expect(error_response[:errors][0]).to eq("Invalid parameter passed. Valid parameters: name")
    end

    it 'returns error if any invalid parameter is passed' do
      get '/api/v1/merchants/find?name=Mart&min_price=50'
  
      expect(response.status).to eq(400)
  
      error_response = JSON.parse(response.body, symbolize_names: true)
  
      expect(error_response).to have_key(:message)
      expect(error_response[:message]).to eq("Your query could not be completed")
  
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)
  
      expect(error_response[:errors][0]).to eq("Invalid parameter passed. Valid parameters: name")
    end
  end
end