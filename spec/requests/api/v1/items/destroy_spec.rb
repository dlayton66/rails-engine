require 'rails_helper'

RSpec.describe 'destroy an item' do
  it 'can destroy an item' do
    item_id = create(:item).id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item_id}"
    
    expect(response.status).to eq(204)
    expect(response.body).to eq("")
    expect(Item.count).to eq(0)
    expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns a JSON error if record not found' do
    delete "/api/v1/items/-1"

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("Your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_a(Array)

    expect(error_response[:errors][0]).to eq("Couldn't find Item with 'id'=-1")
  end
end