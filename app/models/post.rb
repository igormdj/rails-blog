class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy

    validates :title, presence: true
    validates :content, presence: true


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
