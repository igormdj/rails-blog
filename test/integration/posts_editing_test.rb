require "test_helper"

class PostsEditingTest < ActionDispatch::IntegrationTest
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
      title: "Post Original",
      content: "Conteúdo original do post",
      user: @user
    )
  end
  
  teardown do
    Post.delete_all
    User.delete_all
  end

  test "dono do post pode acessar página de edição" do
    sign_in @user
    get edit_post_path(@post)
    assert_response :success
    assert_select "form"
    assert_select "input[value='Post Original']"
  end

  test "outro usuário não pode acessar página de edição" do
    sign_in @outro_user
    get edit_post_path(@post)
    assert_redirected_to posts_path
    follow_redirect!
    assert_select "div.alert", /Você não tem permissão/
  end

  test "dono do post pode atualizar com dados válidos" do
    sign_in @user
    
    patch post_path(@post), params: {
      post: {
        title: "Post Atualizado",
        content: "Conteúdo atualizado"
      }
    }
    
    assert_redirected_to post_path(@post)
    follow_redirect!
    assert_select "div.notice", /Post atualizado/
    assert_select "h1", "Post Atualizado"
    
    @post.reload
    assert_equal "Post Atualizado", @post.title
    assert_equal "Conteúdo atualizado", @post.content
  end

  test "dono do post não pode atualizar com dados inválidos" do
    sign_in @user
    
    patch post_path(@post), params: {
      post: {
        title: "",
        content: "Conteúdo"
      }
    }
    
    assert_response :unprocessable_entity
    assert_select "div", /Título não pode ficar em branco/
    
    @post.reload
    assert_not_equal "", @post.title
    assert_equal "Post Original", @post.title
  end

  test "outro usuário não pode atualizar o post" do
    sign_in @outro_user
    
    patch post_path(@post), params: {
      post: {
        title: "Tentativa de Hack",
        content: "Conteúdo hackeado"
      }
    }
    
    assert_redirected_to posts_path
    
    @post.reload
    assert_not_equal "Tentativa de Hack", @post.title
    assert_equal "Post Original", @post.title
  end
end