class PlaylistsController < ApplicationController

	before_action :check_listner
	

	def create
		if params[:title] && params[:songs]
			playlist = @current_user.playlists.new(title: params[:title])
			playlist.song_ids = params[:songs]
			if playlist.save
				render json: {playlist: {title: params[:title]}}
			else
				render json: {error: playlist.errors.full_messages}
			end
		else
			render json: {error: "Field must be present"}
		end
	end

	def destroy
		if params[:id]
			playlist = @current_user.playlists.find_by_id(params[:id])
			if playlist
				playlist.destroy
				render json: {error: "Playlist Deleted Successfully"}
			else
				render json: {error: "playlist not exist"}, status: 400
			end
		else
			render json: {error: "id must be provided"}, status: 400
		end
	end

	def update
		if params[:songs]
			playlist = @current_user.playlists.find_by_id(params[:id])
			if playlist
				songs = playlist.song_ids
				new_songs = params[:songs]
				new_songs.each do |song|
					songs.push(song)
				end
				playlist.song_ids = songs
				render json: {message: "Song Added to Playlist Successfully"}
			else
				render json: {error: "playlist not exist"}, status: 400
			end
		else
			render json: {error: "Provide all fields"}
		end
	end

	def index
		playlists = @current_user.playlists
		if playlists || playlists.length != 0
			result = []
			playlists.each do |list|
				h = Hash.new
				h[:title] = list.title
				result.push(h)
			end
			render json: {message: result}
		else
			render json: {error: "playlists does not exist"}, status: 400
		end
	end

	def show
		playlist = @current_user.playlists.find_by_id(params[:id])
		if playlist
			songs = playlist.songs
			render json: songs
		else
			render json: {error: "playlists does not exist"}
		end
	end

	private
	def check_listner
		if @current_user.type != 'Listner'
			render json: {error: "Not Allowed"}, status: 400
		end
	end

	# def playlists_params
	# 	params.permit(:title, :songs)
	# end
end
