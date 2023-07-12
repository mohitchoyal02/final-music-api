class ApiController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  private
  def authenticate_request
    # byebug
    begin
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue
      render json: { error: "unauthorized user" }, status: :unauthorized
    end
  end

  def is_valid(param)
    return (param && !param.strip.blank?)
  end
end