require "test_helper"

class PostTest < ActiveSupport::TestCase
  #configuração para usar FactoryBot
  include FactoryBot::Syntax::Methods

  #executa antes de cada teste
  setup do
    @user = create(:user) #cria um usuário usando a factory
  end

  # =============== TESTES DE VALIDAÇÃO ===============

  test "deve ser valido com titulo e conteudo" do
    post = Post.new(
 title: "Título válido",
      content: "Conteúdo válido para o post",
      user: @user
    )
    assert post.valid?
  end

  test "deve ser inválido sem título" do
    post = Post.new(
      title: nil,
      content: "Conteúdo qualquer",
      user: @user
    )
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "deve ser inválido sem conteúdo" do
    post = Post.new(
      title: "Título qualquer",
      content: nil,
      user: @user
    )
    assert_not post.valid?
    assert_includes post.errors[:content], "can't be blank"
  end

  test "deve ser inválido sem usuário" do
    post = Post.new(
      title: "Título qualquer",
      content: "Conteúdo qualquer",
      user: nil
    )
    assert_not post.valid?
    assert_includes post.errors[:user], "must exist"
  end

  # ========== TESTES DE RELACIONAMENTOS ==========

  test "pertence a um usuário" do
    post = create(:post, user: @user)
    assert_equal @user.id, post.user_id
    assert_instance_of User, post.user
  end

  test "tem muitos comentários" do
    post = create(:post, user: @user)
    comment1 = Comment.create!(content: "Comentário 1", post: post, user: @user)
    comment2 = Comment.create!(content: "Comentário 2", post: post, user: @user)
    
    assert_equal 2, post.comments.count
    assert_includes post.comments, comment1
    assert_includes post.comments, comment2
  end

  test "deleta comentários quando o post é deletado" do
    post = create(:post, user: @user)
    comment = Comment.create!(content: "Comentário", post: post, user: @user)
    
    assert_difference 'Comment.count', -1 do
      post.destroy
    end
  end

  # ========== TESTES DO MÉTODO DE BUSCA ==========

  test "busca por título" do
    # Cria posts específicos
    create(:post, title: "Ruby on Rails", content: "Conteúdo normal", user: @user)
    create(:post, title: "Python Django", content: "Outro conteúdo", user: @user)
    create(:post, title: "JavaScript React", content: "Mais conteúdo", user: @user)
    
    # Busca por "Ruby"
    resultados = Post.search("Ruby")
    
    assert_equal 1, resultados.count
    assert resultados.first.title.include?("Ruby")
  end

  test "busca por conteúdo" do
    create(:post, title: "Título 1", content: "Aprendendo Ruby", user: @user)
    create(:post, title: "Título 2", content: "Estudando Python", user: @user)
    create(:post, title: "Título 3", content: "Praticando Rails", user: @user)
    
    # Busca por "Ruby" no conteúdo
    resultados = Post.search("Ruby")
    
    assert_equal 1, resultados.count
    assert resultados.first.content.include?("Ruby")
  end

  test "busca por título ou conteúdo" do
    create(:post, title: "Ruby on Rails", content: "Conteúdo comum", user: @user)
    create(:post, title: "Título comum", content: "Aprendendo Ruby", user: @user)
    create(:post, title: "Python", content: "Estudando Python", user: @user)
    
    # Busca por "Ruby" (encontra no título E no conteúdo)
    resultados = Post.search("Ruby")
    
    assert_equal 2, resultados.count
  end

  test "busca com termo vazio retorna todos os posts" do
    create_list(:post, 5, user: @user)  # Cria 5 posts
    
    resultados = Post.search("")
    
    assert_equal 5, resultados.count
  end

  test "busca com termo nil retorna todos os posts" do
    create_list(:post, 3, user: @user)
    
    resultados = Post.search(nil)
    
    assert_equal 3, resultados.count
  end

  test "busca sem resultados retorna vazio" do
    create(:post, title: "Ruby", content: "Conteúdo", user: @user)
    
    resultados = Post.search("Python")
    
    assert_equal 0, resultados.count
    assert_empty resultados
  end

  test "busca é case insensitive" do
    create(:post, title: "RUBY ON RAILS", content: "Conteúdo", user: @user)
    
    # Buscar com letras minúsculas
    resultados = Post.search("ruby")
    
    assert_equal 1, resultados.count
  end

  test "busca por termo parcial" do
    create(:post, title: "Aprendendo Ruby on Rails", content: "Conteúdo", user: @user)
    
    # Buscar parte da palavra
    resultados = Post.search("Rails")
    
    assert_equal 1, resultados.count
  end

  # ========== TESTES DE ORDENAÇÃO ==========

  test "posts são ordenados por data de criação decrescente" do
    post1 = create(:post, user: @user, created_at: 2.days.ago)
    post2 = create(:post, user: @user, created_at: 1.day.ago)
    post3 = create(:post, user: @user, created_at: Time.current)
    
    posts = Post.order(created_at: :desc)
    
    assert_equal post3, posts.first
    assert_equal post2, posts.second
    assert_equal post1, posts.third
  end

  # ========== TESTE DE MÉTODO TO_S (se existir) ==========

  test "to_s retorna o título" do
    post = create(:post, title: "Meu Post", user: @user)
    assert_equal "Meu Post", post.to_s
  end

  # ========== TESTES ADICIONAIS ==========

  test "título deve ter no mínimo 2 caracteres" do
    post = Post.new(title: "A", content: "Conteúdo válido", user: @user)
    
    # Se você adicionou essa validação no model
    if post.respond_to?(:valid?)
      assert_not post.valid? if post.title.length < 2
    end
  end

  test "conteúdo deve ter no mínimo 5 caracteres" do
    post = Post.new(title: "Título válido", content: "ABC", user: @user)
    
    # Se você adicionou essa validação no model
    if post.respond_to?(:valid?)
      assert_not post.valid? if post.content.length < 5
    end
  end
end

