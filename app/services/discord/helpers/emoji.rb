# frozen_string_literal: true

module Discord::Helpers::Emoji
  CROSS_MARK = '❌'
  CHECK_MARK = '✅'
  SKIP_DIALOG = '▶️'
  LETTERS = %w[🇦 🇧 🇨 🇩 🇪 🇫 🇬 🇭 🇮 🇯 🇰 🇱 🇲 🇳 🇴 🇵 🇶 🇷 🇸 🇹 🇺 🇻 🇼 🇽 🇾 🇿].freeze

  # @param emoji_name [String] Emoji or array of emojis
  # @param index [Integer] Wanted emoji (in case of fetching an array)
  # @return [String] Containing emoji
  def self.fetch_emoji(emoji_name, index = nil)
    emoji_constant_name = emoji_name.to_s.upcase
    emoji_constant = "#{self}::#{emoji_constant_name}".constantize
    index.nil? ? emoji_constant : emoji_constant[index]
  end
end
