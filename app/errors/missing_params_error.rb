class MissingParamsError < StandardError
  def message
    "Parameters cannot be missing"
  end
end