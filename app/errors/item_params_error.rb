class ItemParamsError < StandardError
  def message
    "Invalid parameter passed. Valid parameters: name, min_price, max_price"
  end
end