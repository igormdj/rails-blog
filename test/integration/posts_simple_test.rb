require "test_helper"

class PostsSimpleTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "página inicial carrega" do
    get root_path
    assert_response :success
  end
  
  test "página de novo post redireciona se não logado" do
    get new_post_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  test "usuário logado pode criar post" do
    # Criar usuário
    user = User.create!(
      email: "teste@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
    
    # Fazer login
    sign_in user
    
    # Contar posts antes
    posts_antes = Post.count
    
    # Criar post
    post posts_path, params: {
      post: {
        title: "Post Teste",
        content: "Conteúdo do post teste"
      }
    }
    
    # Verificar se criou
    posts_depois = Post.count
    assert_equal posts_antes + 1, posts_depois
    
    # Verificar redirecionamento
    assert_redirected_to root_path
  end
end