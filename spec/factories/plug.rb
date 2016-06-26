# spec/factories/plug.rb

FactoryGirl.define do
    factory :plug do
        name                    { "Test Plug" }
        feed_id                 { "int_test"  }
    end
end