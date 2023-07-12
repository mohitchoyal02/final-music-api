class ListnersController < ApiController
  skip_before_action :authenticate_request, only: [:create, :login]
  before_action :check_listner, only: [:update, :destroy, :update_listner, :recently_played]

  def create
    if is_valid(params[:username]) && params[:password] && params[:email] && params[:full_name] && params[:genre_type]

      listner = Listner.new(listner_params)
      if listner.save
        render json: listner
      else
        render json: {error: listner.errors.full_messages}
      end
    else
      render json: { error: "Fields can't be empty "}
      
    end
  end

  def login
    if params[:username] && params[:password]
      listner = Listner.find_by(username: params[:username])
      if listner && listner.password == params[:password]
        token = jwt_encode({user_id: listner.id, user_type: listner.type})
        render json: { token: token }
      else
        render json: { error: "Invalid username or password" }
      end
    else
      render json: { error: "can't be blank entity" }
    end
  end

  def update
    if is_valid(params[:curr_password]) && is_valid(params[:new_password])
      if @current_user.password == params[:curr_password]
        if params[:new_password] != params[:curr_password]
          @current_user.update(password: params[:new_password])
          render json: { message: "Password updated" }, status: :ok
        else
          render json: { message: "Password should be different from new Password" }, status: 400
        end
      else
        render json: { error: "Invalid credentials" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Provide all fields" }
    end
  end

  def update_listner
    username = is_valid(params[:username]) ? params[:username] : @current_user.username
    full_name = is_valid(params[:full_name]) ? params[:full_name] : @current_user.full_name
    email = is_valid(params[:email])? params[:email] : @current_user.email
    genre_type = is_valid(params[:genre_type])? params[:genre] : @current_user.genre_type

    begin
      @current_user.update(username: username, full_name: full_name, email: email, genre_type: genre_type)
      render json: { message: "Listner Updated" }
    rescue Exception => e
      render json: { error: e.to_s }
    end

  end

  def destroy_listner
    # if params[:id]
      # artist = @current_user.find_by_id(params[:id])
      # if artist
      @current_user.delete
      render json: { message: "Listner Deleted" }, status: 202
      # else
      #   render json:{error: "can't find listner with given id"}
      # end
    # else
      # render json: {error: "can't find"}, status: :unprocessable_entity
    # end
  end


  private
  def listner_params
    params.permit(:email, :full_name, :username, :password, :genre_type)
  end

  def check_listner
    if @current_user.type != 'Listner'
      render json: { error: "Not Allowed" }, status: 400
    end
  end
end
