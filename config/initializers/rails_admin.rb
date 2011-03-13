RailsAdmin.config do |config|

config.model Newsitem do
  edit do
    field :title do end
    field :subtitle do end
    field :visible do end
    field :body do
      #ckeditor do 
      #  true
      #end
    end
  end
end

end