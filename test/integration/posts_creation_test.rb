require "test_helper"

class PostsCreationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    # Criar um usuário para os testes
    @user = User.create!(
      email: "teste@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
  end
  
  teardown do
    # Limpar dados após cada teste
    Post.delete_all
    User.delete_all
  end

  # ========== TESTES DE ACESSO ==========
  
  test "usuário não logado não pode acessar página de novo post" do
    get new_post_path
    assert_redirected_to new_user_session_path
    # Seguir o redirecionamento e verificar mensagem (opcional)
    follow_redirect!
    # A mensagem pode estar em inglês ou português
    assert_match /sign in|login|entrar/, response.body
  end

  test "usuário logado pode acessar página de novo post" do
    sign_in @user
    get new_post_path
    assert_response :success
    # Verifica se existe o formulário (pode ser "Novo Post" ou "New Post")
    assert_select "form"
    # Verifica se tem o título (ajuste conforme sua view)
    assert_match /Novo Post|New Post/, response.body
  end

  # ========== TESTES DE CRIAÇÃO COM DADOS VÁLIDOS ==========

  test "usuário logado pode criar um post com dados válidos" do
    sign_in @user
    
    assert_difference 'Post.count', 1 do
      post posts_path, params: {
        post: {
          title: "Meu Post de Teste",
          content: "Este é o conteúdo do meu post de teste. Ele tem mais de 5 caracteres."
        }
      }
    end
    
    # Se seu sistema redireciona para root_path (página inicial)
    assert_redirected_to root_path
    follow_redirect!
    
    # Verificar mensagem de sucesso (ajuste conforme seu sistema)
    assert_match /criado|sucesso/, response.body
  end

  test "post criado deve estar associado ao usuário logado" do
    sign_in @user
    
    post posts_path, params: {
      post: {
        title: "Post do Usuário",
        content: "Conteúdo do post com mais de 5 caracteres"
      }
    }
    
    novo_post = Post.last
    assert_equal @user.id, novo_post.user_id
    assert_equal @user.email, novo_post.user.email
  end

  # ========== TESTES COM DADOS INVÁLIDOS ==========

  test "usuário logado não pode criar post sem título" do
    sign_in @user
    
    assert_no_difference 'Post.count' do
      post posts_path, params: {
        post: {
          title: "",
          content: "Conteúdo válido com mais de 5 caracteres"
        }
      }
    end
    
    # Deve renderizar o formulário novamente com erro
    assert_response :unprocessable_entity
    # Verificar mensagem de erro (pode ser "can't be blank" ou "não pode ficar em branco")
    assert_match /blank|vazio|branco/, response.body
  end

  test "usuário logado não pode criar post sem conteúdo" do
    sign_in @user
    
    assert_no_difference 'Post.count' do
      post posts_path, params: {
        post: {
          title: "Título válido",
          content: ""
        }
      }
    end
    
    assert_response :unprocessable_entity
    assert_match /blank|vazio|branco/, response.body
  end

  # ========== TESTES DE REDIRECIONAMENTO ==========

  test "após criar post, redireciona para a página inicial" do
    sign_in @user
    
    post posts_path, params: {
      post: {
        title: "Redirecionamento Teste",
        content: "Conteúdo do post com mais de 5 caracteres"
      }
    }
    
    # Se seu sistema redireciona para root_path
    assert_redirected_to root_path
    
    # Verificar mensagem flash
    assert_match /criado|sucesso/, flash[:notice] if flash[:notice]
  end

  # ========== TESTES DE SEGURANÇA ==========

  test "usuário não pode criar post para outro usuário" do
    outro_usuario = User.create!(
      email: "outro@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
    
    sign_in @user
    
    # Tenta criar post com user_id de outro usuário
    post posts_path, params: {
      post: {
        title: "Tentativa de Hack",
        content: "Conteúdo com mais de 5 caracteres",
        user_id: outro_usuario.id
      }
    }
    
    novo_post = Post.last
    assert_not_equal outro_usuario.id, novo_post.user_id if novo_post
    if novo_post
      assert_equal @user.id, novo_post.user_id
    end
  end

  # ========== TESTE COM REDIRECIONAMENTO APÓS LOGIN ==========

  test "criação de post requer autenticação" do
    # Usuário não logado
    assert_no_difference 'Post.count' do
      post posts_path, params: {
        post: {
          title: "Post sem login",
          content: "Isso não deveria ser criado"
        }
      }
    end
    
    assert_redirected_to new_user_session_path
  end
end