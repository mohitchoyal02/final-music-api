ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  
  actions :index, :show, :edit
  form do |f|
    f.inputs do 
      f.input :type, as: :select, collection: [:Artist, :Listner]
      f.input :full_name
      f.input :email
      f.input :username
      f.input :password_digest
      f.input :genre_type, as: :select, collection: %i[hip-hop pop rock]
    end
    f.actions
  end

  index do 
    column :id
    column :full_name
    column :username
    column :email
    column :genre_type
    column :songs do | song|
      if song.present?
        song.title
      else
        "empty"
      end
      
    end
    actions

  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:type, :username, :password_digest, :full_name, :email, :genre_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
