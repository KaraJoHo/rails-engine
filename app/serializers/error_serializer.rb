class ErrorSerializer 
  def initialize(errors)
    @errors = errors
  end

  def bad_request
    {
      message: "your query could not be completed",
      errors: @errors
    }
  end

  # def self.response_for_400
  #   {
  #     message: "your query could not be completed",
  #     data: {
  #             error: @errors, 
  #             id: nil, 
  #             attributes: {}, 
  #           }
  #   }
  # end
end