class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: %i[show destroy update]
  
  def index
    page = params.fetch(:page, 1)
    per_page = params.fetch(:per_page, 20)
    items = Item.offset((page-1)*per_page).limit(per_page)
    render json: ItemSerializer.new(items)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def destroy
    Item.destroy(@item.id)
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