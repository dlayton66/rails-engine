class EmptyParamsError < StandardError
  def message
    "Parameters cannot be empty"
  end
end