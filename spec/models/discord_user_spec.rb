require 'rails_helper'

RSpec.describe DiscordUser do
  context 'validations' do
    it { should validate_uniqueness_of(:discord_id) }
  end
end
