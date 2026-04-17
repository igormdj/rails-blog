class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  #validação para evitar duplicidade (mesmo post com mesma tag)
  validates :post_id, uniqueness: { scope: :tag_id, message: "já possui esta tag" }
end
