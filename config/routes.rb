Rails.application.routes.draw do
  scope :artists do 
    resources :artists
  end
end
