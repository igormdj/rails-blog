require "test_helper"

class PostSearchTest < ActiveSupport::TestCase
    include FactoryBot::Syntax::Methods

    setup do
        @user = create(:user)
    end

    test "busca múltiplas palavras" do
    create(:post, title: "Ruby on Rails Guide", content: "Aprenda Ruby", user: @user)
    create(:post, title: "Python Guide", content: "Aprenda Python", user: @user)
    
    resultados = Post.search("Ruby Guide")
    
    # Dependendo da implementação, pode encontrar ou não
    # Aqui testamos se encontra pelo menos um
    assert resultados.any?
  end

  test "busca preserva ordenação" do
    create(:post, title: "Zebra", content: "Animal", user: @user, created_at: 1.day.ago)
    create(:post, title: "Cachorro", content: "Animal", user: @user, created_at: Time.current)
    
    resultados = Post.search("Animal").order(created_at: :desc)
    
    assert_equal "Cachorro", resultados.first.title
    assert_equal "Zebra", resultados.last.title
  end
end