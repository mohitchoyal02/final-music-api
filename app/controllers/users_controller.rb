class UsersController < ApiController
	skip_before_action :authenticate_request, only: [:create, :login]

	def create
    # if is_valid(params[:username]) && params[:password] && params[:email] && params[:full_name] && params[:genre_type]
    user = User.new(user_params)
    if params[:password] && params[:password].length > 4 && params[:password].length < 10
      user.password = params[:password]
      # byebug
      if user.save
        render json: { data: UserSerializer.new(user), success: true }, status: 201
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "password must be in range 4-10"}, status: :unprocessable_entity
    end
  # else
    # render json: { error: "Fields can't be empty "}
  # end
  end

  def login
    if params[:username] && params[:password]
      user = User.find_by(username: params[:username])
      if user && user.password == params[:password]
        token = jwt_encode({user_id: user.id})
        render json: {token: token, success: true}, status: 200
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    else
      render json: { error: "can't be blank entity" }, status: :unprocessable_entity
    end
  end

  def update_user
    username = is_valid(params[:username]) ? params[:username] : @current_user.username
    full_name = is_valid(params[:full_name]) ? params[:full_name] : @current_user.full_name
    email = is_valid(params[:email])? params[:email] : @current_user.email
    genre_type = is_valid(params[:genre_type])? params[:genre] : @current_user.genre_type

    begin
      @current_user.update(username: username, full_name: full_name, email: email, genre_type: genre_type)
      render json: { message: "User Updated", data: UserSerializer.new(@current_user) }
    rescue Exception => e
      render json: { error: e.to_s }, status: 400
    end
  end

  def update_password
    if is_valid(params[:curr_password]) && is_valid(params[:new_password])
      if @current_user.password == params[:curr_password]
        if params[:new_password] != params[:curr_password]
          @current_user.update(password: params[:new_password])
          render json: { message: "Password updated" }, status: :ok
        else
          render json: { error: "New Password Should be different from old password" }, status: 400
        end
      else
        render json: { error: "Invalid credentials" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Provide all fields" }, status: :unprocessable_entity
    end
  end

  # For Testing Purpose only
  def index
    users = User.all
    if users.empty?
      render json: { message: "No user Found"}, status: 400
    else
      render json: users, status: 200
    end
  end


  def destroy_user
    if @current_user
      @current_user.destroy
      render json: { message: "User Account Deleted" }, status: 202
    else
      render json:{ error: "can't find artist" }, status: 400
    end
  end

  private
  def user_params
    params.permit(:email, :full_name, :username, :password, :genre_type, :type)
  end
end
