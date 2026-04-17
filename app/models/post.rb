class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy

      # ========== RELACIONAMENTO COM TAGS ==========
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags

    validates :title, presence: true
    validates :content, presence: true

    # ========= MÉTODOS PARA TAGS ==========

    # Adicionar uma tag ao post

    def add_tag(tag_name)
        tag = Tag.find_or_create_by(name: tag_name.downcase.strip)
        tags << tag unless tags.include?(tag)
    end

    #remover uma tag do post (por nome)
    def remove_tag(tag_name)
        tag = Tag.find_by(name: tag_name.downcase.strip)
        tags.delete(tag) if tag
    end

    #verificar se o post tem uma tag específica
    def has_tag?(tag_name)
        tags.exists?(name: tag_name.downcase.strip)
    end

    #retornar tags como string separada por virgula
    def tag_list
        tags.pluck(:name).join(", ")
    end

    #definir tags a partir de uma string separada por virgula
    def tag_list=(value)
        #limpa tags existentes
        self.tags.clear

        #divide a string por virgula e remove espaços 
        value.to_s.split(",").each do |tag_name|
            add_tag(tag_name.strip)
        end
    end

    # ========= SCOPES ========

    scope :recentes, -> { order(created_at: :desc) }
    
    # Posts mais antigos primeiro (do mais antigo para o mais novo)
    scope :antigos, -> { order(created_at: :asc) }
    
    # Posts da última semana
    scope :ultima_semana, -> { where('created_at >= ?', 7.days.ago) }
    
    # Busca por título (scope com parâmetro)
    scope :por_titulo, ->(titulo) { where('title LIKE ?', "%#{titulo}%") if titulo.present? }

    # ========= MÉTODOS DE CLASSE ========

    def self.search(query)
        if query.present?
            where("title LIKE ? OR content LIKE ?", "%#{query}%", "%#{query}%")
        else
            all
        end
    end
end
