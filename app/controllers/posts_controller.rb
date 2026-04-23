class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def index
        @posts = Post.recentes.page(params[:page]).per(10)
    end

    def show
    end
    
    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)

        if @post.save
            redirect_to @post, flash: { success: 'Post criado com sucesso!'}
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @post.update(post_params)
            redirect_to @post, flash: { success: 'Post atualizado com sucesso!' }
        else
            flash.now[:warning] = 'Erro ao atualizar post. Verifique os campos.'
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @post.destroy
        redirect_to root_path, flash: { info: 'Post excluído com sucesso!' }
    end

    private

    def set_post
        @post = Post.find(params[:id])
    end

    def post_params
        #adicionar :tag_list aos parametros permitidos
        params.require(:post).permit(:title, :content, :tag_list)
    end
    
    def authorize_user!
        unless @post.user == current_user
            redirect_to posts_path, flash: { alert: 'Você não tem permissão para isso.' }
        end
    end
end