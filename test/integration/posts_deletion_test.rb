require "test_helper"

class PostsDeletionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = User.create!(
      email: "teste@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
    
    @outro_user = User.create!(
      email: "outro@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
    
    @post = Post.create!(
      title: "Post para Deletar",
      content: "Conteúdo do post",
      user: @user
    )
  end
  
  teardown do
    Post.delete_all
    User.delete_all
  end

  test "dono do post pode deletar seu próprio post" do
    sign_in @user
    
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end
    
    assert_redirected_to root_path
    follow_redirect!
    assert_select "div.notice", /Post excluído/
  end

  test "outro usuário não pode deletar o post" do
    sign_in @outro_user
    
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    
    assert_redirected_to posts_path
    follow_redirect!
    assert_select "div.alert", /Você não tem permissão/
    
    # Verifica que o post ainda existe
    assert_not_nil Post.find_by(id: @post.id)
  end

  test "usuário não logado não pode deletar post" do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    
    assert_redirected_to new_user_session_path
  end
  
  test "deleta todos os comentários quando post é deletado" do
    # Criar comentários no post
    Comment.create!(content: "Comentário 1", post: @post, user: @user)
    Comment.create!(content: "Comentário 2", post: @post, user: @user)
    
    assert_equal 2, @post.comments.count
    
    sign_in @user
    
    assert_difference 'Comment.count', -2 do
      delete post_path(@post)
    end
  end
end