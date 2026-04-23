module ApplicationHelper
    # ======== FORMATAÇÃO DE DATAS ========

    # FORMATA DATA NO PADRÃO BRASILEIRO: 25/12/2024
    def formatar_data(data)
        return "Data não informada" unless data.present?
        data.strftime("%d/%m/%Y")
    end

    # FORMATA DATA E HORA: 25/12/2024 14:30
    def formatar_data_hora(data)
        return "Data e hora não informados" unless data.present?
        data.strftime("%d/%m/%Y às %H:%M")
    end

    #FORMATA DATA COMPLETA COM DIA DA SEMANA: Quarta-feira, 25 de dezembro de 2024
    def formatar_data_completa(data)
        return "Data não informada" unless data.present?
        data.strftime("%A, %d de %B de %Y")
    end

    # FORMATA DATA RELATIVA (EX: "há 3 dias", "ONTEM", "HOJE")
    def formatar_data_relativa(data)
        return "Data não informada" unless data.present?

        dias = (Date.current - data.to_date).to_i

        case dias
        when 0
            "hoje"
        when 1
            "ontem"
        when 2..7
            "há #{dias} dias"
        else
            formatar_data(data)
        end
    end

    # FORMATA DATA CURTA: 25/12
    def formatar_data_curta(data)
        return "Data não informada" unless data.present?
        data.strftime("%d/%m")
    end

    #FORMATA APENAS HORA: 14:30
    def formatar_hora(data)
        return "Hora não informada" unless data.present?
        data.strftime("%H:%M")
    end

    #formata data no formato ISO: 2024-12-25
    def formatar_data_iso(data)
        return "Data não informada" unless data.present?
        data.strftime("%Y-%m-%d")
    end

    # Formata data com mês por extenso: 25 de Dezembro de 2024
  def formatar_data_mes_extenso(data)
    return "Data não informada" unless data.present?
    data.strftime("%d de %B de %Y")
  end
  
  # Formata data com hora e segundos: 25/12/2024 14:30:45
  def formatar_data_hora_segundos(data)
    return "Data não informada" unless data.present?
    data.strftime("%d/%m/%Y %H:%M:%S")
  end
  
  # Formata data para uso em atributos HTML (ex: data-attributes)
  def formatar_data_html(data)
    return "" unless data.present?
    data.strftime("%Y-%m-%d")
  end

  def formatar_data_i18n(data, formato = :default)
  return "Data não informada" unless data.present?
  I18n.l(data, format: formato)
end

# Uso: formatar_data_i18n(@post.created_at, :long)

end
