FactoryBot.define do
    factory :user do
        email { Faker::Internet.unique.email }
        password { "12345678" }
        password_confirmation { "12345678" }

        #opção: criar um usuário com email especifico
        trait :specific do
            email { 'teste@example.com' }
        end
    end
end
