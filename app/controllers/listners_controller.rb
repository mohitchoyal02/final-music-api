class ListnersController < ApplicationController
	skip_before_action :authenticate_request, only: [:create, :login]

	def create
		listner = Listner.new(listner_params)
		if listner.save
			render json: listner
		else
			render json: {error: listner.errors.full_messages}
		end
	end

	def login
		if params[:username] && params[:password]
			listner = Listner.find_by(username: params[:username])
			if listner && listner.password == params[:password]
				token = jwt_encode({user_id: listner.id, user_type: listner.type})
				render json: {token: token}
			else
				render json: {error: "Invalid username or password"}
			end
		else
			render json: {error: "can't be blank entity"}
		end
	end

	private
	def listner_params
		params.permit(:email, :full_name, :username, :password, :genre_type)
	end
end
