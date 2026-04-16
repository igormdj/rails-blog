class WelcomeController < ApplicationController
  def index

    valid_per_page_options = [5, 10, 15, 20, 50]
    per_page = params[:per_page].to_i
    unless valid_per_page_options.include?(per_page)
      per_page = 10
    end
    
    # Usando o scope :recentes para ordenar os posts por data de criação
    @posts = Post.recentes
                  .search(params[:search])
                  .page(params[:page])
                  .per(per_page)
                  
    @search_term = params[:search]
  end
end
