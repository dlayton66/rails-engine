require 'rails_helper'

RSpec.describe 'get a merchant' do
  it 'can get a merchant by id' do
    merchant_id = create(:merchant).id
    
    get "/api/v1/merchants/#{merchant_id}"

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
  end
end