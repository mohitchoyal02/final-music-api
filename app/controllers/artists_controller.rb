class ArtistsController < ApplicationController
	skip_before_action :authenticate_request, only: [:create, :login]

	def create
		artist = Artist.new(artist_params)
		artist.password = params[:password]

		if artist.save
			render json: artist, status: :created
		else
			render json: artist.errors.full_messages, status: :unprocessable_entity
		end
	end

	def login
		if params[:username] && params[:password]
			artist = Artist.find_by(username: params[:username])
			if artist && artist.password == params[:password]
				token = jwt_encode({user_id: artist.id, user_type: artist.type})
				render json: {token: token}
			else
				render json: {error: "Invalid credentials"}, status: :unauthorized
			end
		else
			render json: {error: "can't be blank entity"}, status: :unprocessable_entity
		end
	end


	private
	def artist_params
		params.permit(:email, :full_name, :username, :password, :genre_type)
	end
end
