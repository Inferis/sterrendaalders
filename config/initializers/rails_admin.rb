RailsAdmin.config do |config|

config.model Newsitem do
  edit do
    field :title {}
    field :subtitle {}
    field :visible {}
    field :body do
      ckeditor do 
        true
      end
    end
  end
end

end