class AlbumsController < ApplicationController
	before_action :check_artist

	

	def create
		if (params[:title] && !params[:title].blank?)&& (params[:songs] && params[:songs].length != 0)
			begin
				album = @current_user.albums.new(title: params[:title])
				album.song_ids= params[:songs]
				if album.save
					render json: {message: 'Albums successfully created'}
				else
					render json: {error: album.errors.full_messages}
				end
			rescue Exception => err
				render json: {error: err.to_s}
			end
		else
			render json: {error: "Fields cannot be empty or blank"}
		end
	end

	def update
		if params[:id]
			album = @current_user.albums.find_by_id(params[:id])
			if album
				title = params[:title] ? params[:title] : album.title
				songs = params[:songs] ? params[:songs] : album.songs

				album.update(title: title, songs: songs)

				render json: {message: 'Album updated successfully'}
			else
				render json: {message: "can't find any album"}, status: 400
			end
		else
			render json: {error: "Can't find without id"}, status: :unprocessable_entity
		end 
	end

	def destroy
		if params[:id]
			album = @current_user.albums.find_by_id(params[:id])
			if album
				album.destroy
				render json: {message: 'Album deleted successfully'}
			else
				render json: {message: "can't find any album"}, status: 400
			end
		else
			render json: {error: "Can't find without id"}, status: :unprocessable_entity
		end 
	end

	def index
		albums = @current_user.albums
		if albums || albums.length != 0
			result = []
			albums.each do |list|
				h = Hash.new
				h[:title] = list.title
				result.push(h)
			end
			render json: {message: result}
		else
			render json: {error: "albums does not exist"}, status: 400
		end
	end

	def show
		albums = @current_user.albums.find_by_id(params[:id])
		if albums
			songs = albums.songs
			result = []
			songs.each do |song|
				h = Hash.new
				h[:title] = song.title
				h[:genre] = song.genre
				h[:artist] = song.artist.full_name
				h[:url] = song.file.url
				result.push(h)
			end
			render json: {message: result}
		else
			render json: {error: "albums does not exist"}
		end
	end


	private
	def check_artist
		if @current_user.type != 'Artist'
			render json: {error: "Not Allowed"}, status: :unauthorized
		end
	end
end
