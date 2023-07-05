Rails.application.routes.draw do
  # scope :artists do 
    resources :artists
    resources :listners
    resources :songs
    post "artists/login", to: "artists#login"
    post "listners/login", to: "listners#login"
  # end
end
