class SearchesController < ApplicationController

  def search
    @search_target = params[:search_target]
    search_type = params[:search_type]

    @keyword = params[:keyword]

    case @search_target
      when 'Users' then
        @results = User.search(@keyword, search_type)
      when 'Books' then
        @results = Book.search(@keyword, search_type)
    end
  end

end
