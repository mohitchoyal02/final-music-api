class SongsController < ApplicationController
	before_action :check_artist, only: [:create]
	before_action :check_listner, only: [:show, :index]
	
	before_action do
    	ActiveStorage::Current.host = request.base_url
  	end

	def create
		# byebug
		if params[:title] && params[:genre] && params[:file]
			song = @current_user.songs.new(song_params)
			song.file.attach(params[:file])

			if song.save
				render json: {message: 'success'}, status: :created
			else
				render json: {message: song.errors.full_messages}
			end
		else
			render json: {error: "Field can't be blank"}
		end
	end

	def show
		begin
			song = Song.find_by(id: params[:id])
			if song
				render json: {title: song.title, url: song.file.url, genre: song.genre, artist: song.user.full_name}, status: :ok
			else
				render json: {error: "Song Not Found"}, status: :not_found
			end
		rescue
			render json: {error: "An Error Occured"}
		end
	end

	def index
		songs = Song.all
		result = []
		songs.each do |song|
			h = Hash.new
			h[:title] = song.title
			h[:artist] = song.user.full_name
			h[:genre] = song.title
			h[:url] = song.file.url
			result.push(h)
		end
		render json: result
	end

	private 
	def check_artist
		if @current_user.type != 'Artist'
			render json: {error: "Not Allowed"}, status: :not_allowed
		end
	end

	def check_listner
		if @current_user.type != 'Listner'
			render json: {error: "Not Allowed"}, status: :not_allowed
		end
	end

	def song_params
		params.permit(:title, :genre, :file)
	end
end
