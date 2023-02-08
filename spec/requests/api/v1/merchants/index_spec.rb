require 'rails_helper'

RSpec.describe 'get all merchants' do
  it 'can get all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)

    merchants = json_response[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'still returns array of data for 0 or 1 merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)

    create(:item)

    get '/api/v1/merchants'

    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response).to have_key(:data)
    expect(json_response[:data]).to be_an(Array)
  end
end