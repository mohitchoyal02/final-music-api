class SongsController < ApplicationController
	before_action :check_artist, only: [:create, :destroy, :top_song]
	before_action :check_listner, only: [:show, :index, :search_song_by_title, :recently_played, :search_song_by_genre]
	
	before_action do
    	ActiveStorage::Current.host = request.base_url
  	end

	def create
		# byebug
		if params[:title] && params[:genre] && params[:file]
			begin
				song = Song.new(song_params)
				song.artist_id = @current_user.id
				song.file.attach(params[:file])

				if song.save
					render json: {message: 'success'}, status: :created
				else
					render json: {message: song.errors.full_messages}
				end
			rescue
				render json: {message: 'error', error: "Error while uploading"}
			end
		else
			render json: {error: "Field can't be blank"}
		end
	end

	def show
		begin
			song = Song.find_by(id: params[:id])
			if song
				song.update(play_count: song.play_count+1)
				@current_user.recents.create(song_id: song.id)
				if song
					render json: {title: song.title, url: song.file.url, genre: song.genre, artist: song.artist.full_name}, status: :ok
				else
					render json: {error: "Song Not Found"}, status: :not_found
				end
			else
				render json: {error: "Song Not Found"}, status: 400
			end
		rescue Exception => e
			render json: {error: "An Error Occured", e: e.to_s}
		end
	end

	def search_song_by_title
		if params[:title] && params[:title].length != 0
			songs = Song.where("title Like ?" ,"%#{params[:title]}%")
			if songs.length == 0
				render json: {message: "Songs not found"}
			else
				result = []
				songs.each do |song|
					h = Hash.new
					h[:title] = song.title
					h[:artist] = song.artist.full_name
					h[:genre] = song.title
					h[:url] = song.file.url
					result.push(h)
				end
				render json: result
			end
		else
			render json: {error: "Please Search Somthing"}
		end
	end

	def search_song_by_genre
		if params[:genre] && params[:genre].length != 0
			songs = Song.where("genre Like ?" ,"%#{params[:genre]}%")
			if songs.length == 0
				render json: {message: "Songs not found"}
			else
				result = []
				songs.each do |song|
					h = Hash.new
					h[:title] = song.title
					h[:artist] = song.artist.full_name
					h[:genre] = song.title
					h[:url] = song.file.url
					result.push(h)
				end
				render json: result
			end
		else
			render json: {error: "Please Search Somthing"}
		end
	end

	def index
		songs = Song.all
		if songs.length == 0
			render json: {message: "Songs not found"}
		else
			result = []
			songs.each do |song|
				h = Hash.new
				h[:title] = song.title
				h[:artist] = song.artist.full_name
				h[:genre] = song.title
				h[:url] = song.file.url
				result.push(h)
			end
			render json: result
		end
	end

	def destroy
		if params[:id]
			song = Song.find_by_id(params[:id])
			if @current_user.id == song.artist_id
				song.destroy
				render json: {message: "Song Deleted"}, status: 204
			else
				render json: {message: "not allowed"}, status: 400
			end
		else
			render json: {error: "Can't find Song"}, status: 400
		end
	end

	def recently_played
		list = @current_user.recents
		if list && list.length != 0
			result = []
			list.each do |l|
				# byebug
				h = Hash.new
				h[:title] = l.song.title
				h[:artist] = l.song.artist.full_name
				h[:genre] = l.song.genre
				h[:url] = l.song.file.url
				result.push(h)
			end
			render json: {songs: result}
		else
			render json: {message: "There is no recently played song"}
		end
	end

	def top_song
		songs = @current_user.songs.order(play_count: :desc).limit(3)
		result = []
		songs.each do |song|
			h = Hash.new
			h[:title] = song.title
			h[:genre] = song.genre
			h[:artist] = song.artist.full_name
			h[:count] = song.play_count
			h[:url] = song.file.url
			result.push(h)
		end
		render json: {songs: result}
	end


	private 
	def check_artist
		if @current_user.type != 'Artist'
			render json: {error: "Not Allowed"}, status: 400
		end
	end

	def check_listner
		if @current_user.type != 'Listner'
			render json: {error: "Not Allowed"}, status: 400
		end
	end

	def song_params
		params.permit(:title, :genre, :file)
	end
end
