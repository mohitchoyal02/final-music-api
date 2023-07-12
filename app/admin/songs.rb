ActiveAdmin.register Song do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :file, :title, :genre, :artist_id, :play_count, :playlist_id, :album_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:file, :title, :genre, :artist_id, :play_count, :playlist_id, :album_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
