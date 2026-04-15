require "test_helper"

class PostSimpleTest < ActiveSupport::TestCase
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

  test "cria post válido" do
    post = Post.new(
      title: "Título Teste",
      content: "Conteúdo Teste",
      user: @user
    )
    
    assert post.valid?
    assert post.save
  end

  test "busca por título" do
    Post.create!(
      title: "Ruby on Rails",
      content: "Conteúdo",
      user: @user
    )
    
    resultados = Post.search("Ruby")
    
    assert_equal 1, resultados.count
  end
end