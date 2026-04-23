class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_comment, only: [:edit, :update, :destroy]

    def create
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
            redirect_to @post, flash: { success: 'Comentário criado com sucesso.' }
        else
            redirect_to @post, flash: { error: @comment.errors.full_messages.to_sentence }
        end
end

def edit
    authorize_comment_owner
end

def update
    authorize_comment_owner

    if @comment.update(comment_params)
        redirect_to @post, flash: { success: 'Comentário atualizado!' }
    else
        render :edit
    end
end

def destroy
    authorize_comment_owner
    @comment.destroy
    redirect_to @post, flash: { info: 'Comentário removido!' }
end

private

def set_post
    @post = Post.find(params[:post_id])
end

def set_comment
    @comment = @post.comments.find(params[:id])
end

def comment_params
    params.require(:comment).permit(:content)
end

def authorize_comment_owner
    unless @comment.user == current_user
        redirect_to @post, flash: { alert: 'Você não tem permissão para isso.' }
    end
end
end