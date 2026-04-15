ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    #EXECUTA ANTES DE CADA TESTE, LIMPA AS TABELAS DE POST E USER PARA GARANTIR UM AMBIENTE LIMPO
    setup do
      #GARANTE QUE O BANCO DE DADOS ESTEJA LIMPO ANTES DE CADA TESTE, EVITANDO INTERFERÊNCIAS ENTRE TESTES
      Post.delete_all
      User.delete_all
    end
  end
end
