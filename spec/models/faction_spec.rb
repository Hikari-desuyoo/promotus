require 'rails_helper'

RSpec.describe Faction, type: :model do
  subject { build(:faction) }
  it { should validate_presence_of(:root_role) }
  it { should validate_presence_of(:title_role) }
  it { should validate_uniqueness_of(:root_role) }
  it { should validate_uniqueness_of(:title_role) }

  context '.create_or_overwrite' do
    context 'when faction with same title' do
      context 'doesnt previously exist' do
        it 'creates faction' do
          faction = Faction.create_or_overwrite(1, 2, 3)
          expected_title = Role.find_by(discord_id: 1)
          expected_root = Role.find_by(discord_id: 2)
          expected_guild = Guild.find_by(discord_id: 3)

          expect(faction.title_role).to eq(expected_title)
          expect(faction.root_role).to eq(expected_root)
          expect(faction.guild).to eq(expected_guild)
          expect(faction).to be_persisted
        end
      end

      context 'previously exist' do
        it 'overwrites faction' do
          original_faction = create(:faction)
          title_role = original_faction.title_role

          faction = Faction.create_or_overwrite(title_role.discord_id, 100, 4)
          expected_root = Role.find_by(discord_id: 100)
          expected_guild = Guild.find_by(discord_id: 4)

          expect(faction.title_role).to eq(title_role)
          expect(faction.root_role).to eq(expected_root)
          expect(faction.guild).to eq(expected_guild)
          expect(faction).to be_persisted
          expect { original_faction.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
