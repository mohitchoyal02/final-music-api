#                              All Actions for Artist Albums
class AlbumsController < ApiController
  before_action :check_artist

  def create
    if is_valid(params[:title]) && (params[:songs] && !params[:songs].empty?)
      songs = @current_user.songs.where(id: params[:songs])
      album = @current_user.albums.new(title: params[:title])
      album.songs = songs
      if album.save
        render json: { message: 'Albums successfully created' }
      else
        render json: { error: album.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Fields cannot be empty or blank' }, status: :unprocessable_entity
    end
  end

  def update
    album = @current_user.albums.find_by_id(params[:id])
    if album
      title = is_valid(params[:title]) ? params[:title] : album.title
      songs = is_valid(params[:songs]) ? params[:songs] : album.songs

      album.update(title: title, songs: songs)

      render json: { message: 'Album updated successfully' }, status: 200
    else
      render json: { message: "can't find any album" }, status: 400
    end
  end

  def destroy
    album = @current_user.albums.find_by_id(params[:id])
    if album
      album.destroy
      render json: { message: 'Album deleted successfully' }, status: 200
    else
      render json: { message: "can't find any album" }, status: 400
    end
  end

  def index
    if params[:title]
      params[:title] = params[:title].strip
    end
    albums = params[:title].blank? ? @current_user.albums : @current_user.albums.where("title LIKE ?", "%#{params[:title]}%")
    if albums || !albums.empty?
      render json: albums, status: 200
    else
      render json: { error: 'albums does not exist' }, status: 400
    end
  end

  def show
    album = @current_user.albums.find_by_id(params[:id])
    if album
      render json: album
    else
      render json: { error: 'albums does not exist' }, status: 400
    end
  end


  private
  def check_artist
    if @current_user.type != 'Artist'
      render json: { error: 'Not Allowed' }, status: :unauthorized
    end
  end
end
