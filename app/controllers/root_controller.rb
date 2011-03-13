class RootController < ApplicationController
  def index
    @newsitems = Newsitem.find_all_by_visible(true, :order => "created_at");
  end
end
