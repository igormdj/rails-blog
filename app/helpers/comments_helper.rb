module CommentsHelper
    #formata data do comentario
    def data_comentario(comment)
        if comment.created_at > 1.day.ago
        formatar_data_relativa(comment.created_at)
        else
            formatar_data_hora(comment.created_at)
        end
    end

    #retorna classe css baseada na idade do comentário
    def classe_comentario(comment)
        if comment.user == current_user
            "meu comentário"
        else
            "comentário de outro usuário"
        end
    end
end
