FactoryBot.define do
  factory :role do
    sequence(:discord_id) { |n| Role.last&.discord_id.to_i + n }
  end
end
