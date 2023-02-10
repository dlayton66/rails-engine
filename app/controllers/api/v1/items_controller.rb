class Api::V1::ItemsController < BaseController
  before_action :get_item, only: %i[show destroy update]
  
  def index
    items = Item.get_items_by_page(params)
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