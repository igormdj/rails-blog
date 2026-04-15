FactoryBot.define do
    factory :post do
        title { Faker::Lorem.sentence(word_count: 3) }
        content { Faker::Lorem.paragraph(sentence_count: 5) }
        user

        #opção: criar um post com título específico
        trait :ruby_post do
            title { "Aprendendo Ruby on Rails" }
            content { "Ruby é uma linguagem maravilhosa para desenvolvimento web. Com Rails, você pode criar aplicações de forma rápida e eficiente." }
        end

        #post com conteúdo específico
        trait :rails_post do
            title { "Dicas de Rails" }
            content { "Rails facilita o desenvolvimento web." }
        end
    end
end