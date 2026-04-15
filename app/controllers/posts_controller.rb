class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def index
        @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to root_path, notice: "Post criado com sucesso!"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
    end

    def edit
    end

    def update
        if @post.update(post_params)
            redirect_to post_path(@post), notice: "Post atualizado com sucesso!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        redirect_to root_path, notice: "Post excluído com sucesso!", status: :see_other
    end

    private

    def set_post
        @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:title, :content)
    end
    
    def authorize_user!
        unless @post.user == current_user
            redirect_to posts_path, alert: "Você não tem permissão para isso."
        end
    end
end