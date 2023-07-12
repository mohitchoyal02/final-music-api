class ArtistsController < ApiController
  skip_before_action :authenticate_request, only: [:create, :login]
  before_action :check_artist, only: [:update, :destroy_artist, :update_artist]

  def create
    if is_valid(params[:username]) && params[:password] && params[:email] && params[:full_name] && params[:genre_type]
    artist = Artist.new(artist_params)
    if params[:password] && params[:password].length > 4 && params[:password].length < 10
      artist.password = params[:password]

      if artist.save
        render json: artist, status: :created
      else
        render json: artist.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { error: "password must be in range 4-10"}
    end
  else
    render json: { error: "Fields can't be empty "}
  end
  end

  def login
    if params[:username] && params[:password]
      artist = Artist.find_by(username: params[:username])
      if artist && artist.password == params[:password]
        token = jwt_encode({user_id: artist.id})
        render json: {token: token}
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    else
      render json: { error: "can't be blank entity" }, status: :unprocessable_entity
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
      render json: { error: "Provide all fields" }
    end
  end

  def update_artist
    username = is_valid(params[:username]) ? params[:username] : @current_user.username
    full_name = is_valid(params[:full_name]) ? params[:full_name] : @current_user.full_name
    email = is_valid(params[:email]) ? params[:email] : @current_user.email
    genre_type = is_valid(params[:genre_type]) ? params[:genre_type] : @current_user.genre_type

    begin
      if @current_user.update(username: username, full_name: full_name, email: email, genre_type: genre_type)
        render json: { message: "Artist Updated" }
      else
        render json: { error: @current_user.errors.full_messages }
      end
    rescue Exception => e
      render json: { error: e.to_s }
    end
  end

  def destroy_artist
    if @current_user
      @current_user.destroy
      render json: { message: "Artist Deleted" }, status: 202
    else
      render json:{ error: "can't find artist" }
    end
  end

  

  private
  def check_artist
    if @current_user.type != 'Artist'
      render json: { error: "Not Allowed" }, status: :unauthorized
    end
  end

    
  def artist_params
    params.permit(:email, :full_name, :username, :password, :genre_type)
  end
end
