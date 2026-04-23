module PostsHelper
    #FORMATA A DATA DE PUBLICAÇÃO DO POST
    def data_publicacao(post)
        return "Data de publicação não informada" unless post.published_at?
        formatar_data_hora(post.published_at)
    end

    #RETORNA CLASSE CSS BASEADA NA IDADE DO POST
    def classe_post_por_idade(post)
        dias = (Date.current - post.created_at.to_date).to_i

        case dias
        when 0
            "post-novo"
            when 1..7
            "post-recente"
            else
            "post-antigo"
        end
    end

    #retorna icone baseado no tipo de post
    def icone_do_post(post)
       if post.tags.include?("video")
        "🎬"
       elsif post.tags.include?("artigo")
        "📝"
       elsif post.tags.include?("tutorial")
        "📚"
       else
        "📄"
       end
    end
end
