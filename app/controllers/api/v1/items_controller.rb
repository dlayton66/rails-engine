class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    get_item
    render json: ItemSerializer.new(@item)
  end

  private
  
    def get_item
      @item = Item.find(params[:id])
    end
end