class ArtistsController < ApplicationController
	skip_before_action :authenticate_request, only: [:create, :login]

	def create
		user = Artist.new(artist_params)
		user.password = params[:password]

		if user.save
			render json: user, status: :created
		else
			render json: user.errors.full_messages, status: :unprocessable_entity
		end
	end

	def login

	end


	private
	def artist_params
		params.require(:artists).permit(:email, :full_name, :username)
	end
end
