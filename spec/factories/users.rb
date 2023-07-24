FactoryBot.define do
	factory :user do
		type {'Artist'}
		username {'rohitchoyal'}
		full_name {'Mohit Choyal'}
		password {'mohitchoyal'}
		email {'mohit@gmail.com'}
		genre_type {'rock'}
	end
end