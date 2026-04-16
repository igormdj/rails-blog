require "test_helper"

class PostScopeTeste < ActiveSupport::TestCase
    setup do 
        @user = User.create!(
        email: "teste@example.com",
      password: "12345678",
      password_confirmation: "12345678"
    )
    
    # Criar posts com datas diferentes
    @post_antigo = Post.create!(
      title: "Post Antigo",
      content: "Conteúdo do post antigo",
      user: @user,
      created_at: 10.days.ago
    )
    
    @post_medio = Post.create!(
      title: "Post Médio",
      content: "Conteúdo do post médio",
      user: @user,
      created_at: 5.days.ago
    )
    
    @post_novo = Post.create!(
      title: "Post Novo",
      content: "Conteúdo do post novo",
      user: @user,
      created_at: 1.day.ago
    )
  end
  
  teardown do
    Post.delete_all
    User.delete_all
  end

  test "scope recentes ordena do mais novo para o mais antigo" do
    posts = Post.recentes
    assert_equal @post_novo, posts.first
    assert_equal @post_medio, posts.second
    assert_equal @post_antigo, posts.third
  end

  test "scope antigos ordena do mais antigo para o mais novo" do
    posts = Post.antigos
    assert_equal @post_antigo, posts.first
    assert_equal @post_medio, posts.second
    assert_equal @post_novo, posts.third
  end

  test "scope ultima_semana retorna apenas posts dos últimos 7 dias" do
    posts = Post.ultima_semana
    assert_includes posts, @post_novo
    assert_includes posts, @post_medio
    assert_not_includes posts, @post_antigo
  end

  test "pode combinar scopes" do
    posts = Post.recentes.ultima_semana
    assert_equal @post_novo, posts.first
    assert_equal @post_medio, posts.second
    assert_equal 2, posts.count
  end
  
  test "scope por_titulo encontra posts pelo título" do
    posts = Post.por_titulo("Novo")
    assert_includes posts, @post_novo
    assert_not_includes posts, @post_antigo
  end
end