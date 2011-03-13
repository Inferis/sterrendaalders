class RootController < ApplicationController
  def index
    @newsitems = Newsitem.find_all_by_visible(true);
  end
end
