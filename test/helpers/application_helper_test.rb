require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  
  test "formatar_data retorna data formatada" do
    data = Time.new(2024, 12, 25, 14, 30, 0)
    assert_equal "25/12/2024", formatar_data(data)
  end
  
  test "formatar_data retorna mensagem quando data é nil" do
    assert_equal "Data não informada", formatar_data(nil)
  end
  
  test "formatar_data_hora retorna data com hora" do
    data = Time.new(2024, 12, 25, 14, 30, 0)
    assert_equal "25/12/2024 às 14:30", formatar_data_hora(data)
  end
  
  test "formatar_data_relativa retorna 'Hoje' para data atual" do
    data = Time.current
    assert_equal "Hoje", formatar_data_relativa(data)
  end
  
  test "formatar_data_relativa retorna 'Ontem' para data de ontem" do
    data = 1.day.ago
    assert_equal "Ontem", formatar_data_relativa(data)
  end
  
  test "formatar_data_relativa retorna 'Há X dias' para datas antigas" do
    data = 3.days.ago
    assert_equal "Há 3 dias", formatar_data_relativa(data)
  end
end