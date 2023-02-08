class ErrorSerializer
  def initialize(exception)
    @errors = get_errors_array(exception)
  end

  def serialize
    {
      "message": "Your query could not be completed",
      "errors": @errors
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