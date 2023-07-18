Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
    resources :users
    resources :songs
    resources :albums
    resources :playlists
    
    patch "user/update-password", to: "users#update_password"
    delete "user/delete", to:"users#destroy_user"
    put "user/update", to: "users#update_user"
    post "user/login", to: "users#login"
    # get "listner/search", to: "songs#search_song_by_title"
    get "listner/genre-search", to: "songs#search_song_by_genre"
    get "song/recently-played", to: "songs#recently_played"
    get "artist/top-3", to: "songs#top_song"

end
