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
    return (param && !param.blank?)
  end
  def check_artist
    if @current_user.type != 'Artist'
      render json: { error: 'Listners are Not Allowed for this request' }, status: 400
    end
  end

  def check_listner
    if @current_user.type != 'Listner'
      render json: { error: 'Artist are Not Allowed for this request' }, status: 400
    end
  end
end