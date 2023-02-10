class ErrorSerializer
  def initialize(exception = nil)
    @exception = exception
  end

  def serialize
    {
      "message": "Your query could not be completed",
      "errors": get_errors_array(@exception)
    }
  end

  def merchant_serialize
    {
      "data": {
          "id": nil,
          "type": "merchant",
          "attributes": {}
      }
    }
  end

  def item_serialize
    {
      "data": {
          "id": nil,
          "type": "item",
          "attributes": {}
      }
    }
  end

  def get_errors_array(exception)
    if defined?(exception.record)
      exception.record.errors.full_messages
    else
      [exception.message]
    end
  end
end