class PlaylistsController < ApiController

  before_action :check_listner
  

  def create
    if params[:title] && (params[:songs] && !params[:songs].empty?)
      songs = Song.where(id: params[:songs])
      if songs.empty?
        render json: {error: "Songs not found"}, status: :unprocessable_entity
      else
        playlist = @current_user.playlists.create(title: params[:title])
        playlist.songs << songs
        if playlist.save
          render json: playlist, status: 201
        else
          render json: { error: playlist.errors }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: "Field must be present" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id]
      playlist = @current_user.playlists.find_by_id(params[:id])
      if playlist
        playlist.destroy
        render json: { error: "Playlist Deleted Successfully" }, status: 200
      else
        render json: { error: "playlist not exist" }, status: 400
      end
    else
      render json: { error: "id must be provided" }, status: 400
    end
  end

  def update
    if params[:songs]
      playlist = @current_user.playlists.find_by_id(params[:id])
      if playlist
        if verify_songs(params[:songs], playlist.songs.pluck(:id))
          songs =  Song.where(id: params[:songs])
          playlist.songs  << songs
          render json: { message: "Song Added to Playlist Successfully" }, status: 200
        else
          render json: { message: "Song has already been added to Playlist" }, status: 400
        end
      else
        render json: { error: "playlist not exist" }, status: 400
      end
    else
      render json: { error: "Provide all fields" }, status: :unprocessable_entity
    end
  end

  def index
    if params[:title]
      params[:title] = params[:title].strip
    end
    playlists = params[:title].blank? ? @current_user.playlists : @current_user.playlists.where("title LIKE ?", "%#{params[:title]}%")
    if !playlists.empty?
      render json: playlists
    else
      render json: { error: "playlists does not exist" }, status: 400
    end
  end

  def show
    playlist = @current_user.playlists.find_by_id(params[:id])
    if playlist
      # songs = playlist.songs
      render json: playlist
    else
      render json: { error: "playlists does not exist" }, status: 400
    end
  end

  private
  def check_listner
    if @current_user.type != 'Listner'
      render json: { error: "Not Allowed" }, status: 400
    end
  end

  def verify_songs(new_songs, old_songs)
    i=0
    j=0
    n = new_songs.length
    m = old_songs.length
    while (i<n && j<m)
     if (new_songs[i] == old_songs[j]) 

      i+=1
      j+=1
      if j == m
        return true;
      else 
        i = i - j + 1;
        j = 0;
      end
    end
    end
    return false
  end
end