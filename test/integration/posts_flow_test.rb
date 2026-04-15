require "test_helper"

class PostsFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = User.create!(
      email: "usuario@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
  end

  test "fluxo completo de criação, visualização, edição e deleção de post" do
    # 1. Fazer login
    sign_in @user
    
    # 2. Acessar página de novo post
    get new_post_path
    assert_response :success
    
    # 3. Criar novo post
    assert_difference 'Post.count', 1 do
      post posts_path, params: {
        post: {
          title: "Meu Post Completo",
          content: "Este é um post com conteúdo completo para testar o fluxo."
        }
      }
    end
    
    # 4. Verificar redirecionamento
    post_criado = Post.last
    assert_redirected_to post_path(post_criado)
    follow_redirect!
    
    # 5. Verificar conteúdo na página
    assert_select "h1", "Meu Post Completo"
    assert_select "p", /Este é um post com conteúdo completo/
    
    # 6. Acessar página de edição
    get edit_post_path(post_criado)
    assert_response :success
    
    # 7. Editar o post
    patch post_path(post_criado), params: {
      post: {
        title: "Post Editado",
        content: "Conteúdo foi atualizado com sucesso."
      }
    }
    
    assert_redirected_to post_path(post_criado)
    follow_redirect!
    
    # 8. Verificar edição
    assert_select "h1", "Post Editado"
    assert_select "p", /Conteúdo foi atualizado/
    
    # 9. Deletar o post
    assert_difference 'Post.count', -1 do
      delete post_path(post_criado)
    end
    
    assert_redirected_to root_path
    follow_redirect!
    
    # 10. Verificar que o post não existe mais
    get post_path(post_criado)
    assert_response :not_found
  end
end