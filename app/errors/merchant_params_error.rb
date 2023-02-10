class MerchantParamsError < StandardError
  def message
    "Invalid parameter passed. Valid parameters: name"
  end
end