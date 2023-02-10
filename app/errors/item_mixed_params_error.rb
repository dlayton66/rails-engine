class ItemMixedParamsError < StandardError
  def message
    "Cannot mix name and price parameters"
  end
end