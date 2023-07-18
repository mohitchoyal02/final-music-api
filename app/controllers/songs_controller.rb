class SongsController < ApiController
  before_action :check_artist, only: [:create, :destroy, :top_song, :update]
  before_action :check_listner, only: [:show, :index, :search_song_by_title, :recently_played, :search_song_by_genre]
  
  

  def create
    # byebug
    if is_valid(params[:title]) && is_valid(params[:genre]) && is_valid(params[:file])
      begin
        song = Song.new(song_params)
        song.artist_id = @current_user.id
        song.file.attach(params[:file])

        if song.save
          render json: song, status: :created
        else
          render json: { message: song.errors }, status: 400
        end
      rescue
        render json: { message: 'error', error: "Error while uploading" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Field can't be blank" }, status: :unprocessable_entity
    end
  end

  def show
    begin
      song = Song.find_by(id: params[:id])
      if song
        song.update(play_count: song.play_count+1)
        @current_user.recents.create(song_id: song.id)
        if song
          render json: song, status: :ok
        else
          render json: { error: "Song Not Found" }, status: :not_found
        end
      else
        render json: { error: "Song Not Found" }, status: 400
      end
    rescue Exception => e
      render json: { error: "An Error Occured", e: e.to_s }, status: 400
    end
  end

  def update
    if params[:id]
      song = @current_user.songs.find_by_id(params[:id])
      if song
        title = params[:title] ? params[:title] : song.title
        genre = params[:genre] ? params[:genre] : song.genre
        song.update(title: title, genre: genre)
        render json: { message: "Song Updated" }, status: 200
      else
        render json: { error: "Song Not Found" }
      end

    else
      render json: { error: "Song Not Found" }
    end
  end

  def search_song_by_genre
    if params[:genre] && params[:genre].length != 0
      songs = Song.where("genre Like ?" ,"%#{params[:genre]}%")
      if songs.length == 0
        render json: { message: "Songs not found" }, status: :unprocessable_entity
      else
        render json: songs, status: 200
      end
    else
      render json: { error: "Please Search Somthing" }, status: 400
    end
  end

  def index
    if params[:title]
      params[:title] = params[:title].strip
    end
    songs = params[:title].blank? ? Song.all : Song.where("title LIKE ?" ,"%#{params[:title]}%")
    if songs.length == 0
      render json: { message: "Songs not found" }
    else
      render json: songs
    end
  end

  def destroy
    if params[:id]
      song = @current_user.songs.find_by_id(params[:id])
      if song
        song.destroy
        render json: { message: "Song Deleted" }
      else
        render json: { message: "Can't find song with id #{params[:id]}" }, status: 400
      end
    else
      render json: { error: "Can't find Song" }, status: 400
    end
  end

  def recently_played
    list = @current_user.recents
    if list && list.length != 0
      render json: list
    else
      render json: { message: "There is no recently played song" }, status: 400
    end
  end

  def top_song
    songs = @current_user.songs.order(play_count: :desc).limit(3)
    render json: songs, status: 200
  end


  private 
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

  def song_params
    params.permit(:title, :genre, :file)
  end
end
