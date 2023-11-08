FactoryBot.define do
  factory :faction do
    guild { create(:guild) }
    title_role { create(:role) }
    root_role { create(:role) }
  end
end
