class AlbumsController < ApplicationController
	before_action :check_artist

	def create
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
	end

	def update
		if params[:id]
			album = Album.find_by_id(params[:id])
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
			album = Album.find_by_id(params[:id])
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


	private
	def check_artist
		if @current_user.type != 'Artist'
			render json: {error: "Not Allowed"}, status: :unauthorized
		end
	end
end
