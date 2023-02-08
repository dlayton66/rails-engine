class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: %i[show destroy update]
  
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def destroy
    Item.destroy(@item.id)
    render json: ItemSerializer.new(@item)
  end

  def update
    if @item.update!(item_params)
      render json: ItemSerializer.new(@item)
    end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def get_item
      @item = Item.find(params[:id])
    end
end