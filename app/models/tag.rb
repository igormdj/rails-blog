class Tag < ApplicationRecord
    #Validações
    validates :name, presence: true, uniqueness: true

    #Relacionamentos
    has_many :post_tags, dependent: :destroy
    has_many :posts, through: :post_tags

    #método para retornar o nome da tag (para exibição)
    def to_s
        name
    end
end
