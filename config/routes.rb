Rails.application.routes.draw do
    resources :artists
    resources :listners
    resources :songs
    resources :albums
    delete "artist/delete", to:"artists#destroy_artist"
    put "artists/update/:id", to: "artists#update_artist"
    put "listners/update/:id", to: "listners#update_listner"
    post "artists/login", to: "artists#login"
    post "listners/login", to: "listners#login"
    get "listner/search", to: "songs#search_song_by_title"
    get "listner/genre-search", to: "songs#search_song_by_genre"
    get "song/recently-played", to: "songs#recently_played"
    get "artist/top-3", to: "songs#top_song"

end
