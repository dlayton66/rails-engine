require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'can get all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get a merchant by id' do
    id = create(:merchant).id
    
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id.to_s)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'can get all items from a merchant' do
    merchant_id = create(:merchant).id
    merchant_items = create_list(:item, 3, merchant_id: merchant_id)
    other_merchant_items = create_list(:item, 3)

    get "/api/v1/merchants/#{merchant_id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
  end
end