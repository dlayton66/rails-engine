class ErrorSerializer
  def initialize(exception)
    @record = exception.record
  end

  def serialize
    {
      "message": "Your query could not be completed",
      "errors": @record.errors.full_messages
    }
  end
end