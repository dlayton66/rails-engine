class MerchantParamsError < StandardError
  def message
    "Can only pass name as a parameter"
  end
end