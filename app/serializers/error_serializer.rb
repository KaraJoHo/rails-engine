class ErrorSerializer 

  def self.response_for_400(error_message) #
    {
      message: "your query could not be completed",
      data: {
              error: error_message, 
              id: nil, 
              attributes: {}, 
            }
    }
  end

  def self.bad_params(error_message) #404
    {
      message: "your query could not be completed",
      errors: [error_message],
      data: {
              id: nil,
              attributes: {}
            }
    }
  end
end