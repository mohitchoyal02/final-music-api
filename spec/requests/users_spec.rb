require 'rails_helper'
require 'spec_helper'

include JsonWebToken

RSpec.describe "Users", type: :request do
  USER_URL = "/users"
  LOGIN_URL = "/user/login"
  UPDATE_URL = '/user/update'
  let(:user) {FactoryBot.create(:user)}

  before(:each) do
    @token = jwt_encode(user_id: user.id)
  end

  describe "GET /index" do
    # byebug
    subject { get USER_URL, headers: {:Authorization=> @token} }

    it "returns 200 response status" do
      # byebug 
      # get USER_URL, headers: {token: @token}
      subject
      # expect(response).to have_http_status(200)
      expect(response.status).to eq(200)
    end

    it "return a successful status" do
      subject
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  describe "CREATE #user" do 
    it "should create a User Account" do
      post USER_URL, params: {'type'=>'Artist', 'username'=>'rohitchoyal', email: 'mohit@gmail.com', 'password'=> 'mohitchoyal', 'full_name'=>'Mohit Choyal', 'genre_type'=>'rock'}
      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)["data"]).to eq(UserSerializer.new(user).serializable_hash)
    end

    it "if some params are missing " do
      post USER_URL, params: {'type'=>'Artist', 'username'=>'mohit_choyal', email: 'mohit@gmail.com', 'password'=> 'mohit', 'full_name'=>'Mohit Choyal'}
      expect(response.status).to eq(422)
    end

    it "if password is too short or long" do
      post USER_URL, params: {'type'=>'Artist', 'username'=>'mohit_choyal', email: 'mohit@gmail.com', 'password'=> 'moh', 'full_name'=>'Mohit Choyal', 'genre_type'=>'rock'}
      expect(response.status).to eq(422)
    end
  end

  describe "LOGIN #user" do 
    it "should have all credentials" do
      post LOGIN_URL, params: {:username => 'mohitchoyal'}#, :password => 'mohit'}

      expect(response.status).to eq(422)
    end

    it "should validate credentials" do
      post LOGIN_URL, params: {:username => 'mohitchoyal', :password => 'mohit'}

      expect(response.status).to eq(401)
    end

    it "should login the user" do 
      # byebug
      post LOGIN_URL, params: {:username=> 'mohitchoyal', :password=>'mohitchoyal'}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['success']).to eq(true)
    end

    it "Update user" do 
      put UPDATE_URL, params: {:username => 'mohitchoyal'}, headers: {Authorization: @token}

      expect(response).to have_http_status(200)
    end
  end
end
