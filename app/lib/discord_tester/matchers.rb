module DiscordTester::Matchers
  RSpec::Matchers.define :be_reacted do |*reactions|
    match do |obj|
      obj = obj.to_e if defined? obj.to_e
      raise ArgumentError, 'Received object is not a double nor responds to .to_e' if obj.class != RSpec::Mocks::Double

      reactions.each do |reaction|
        expect(obj).to receive(:react).with(reaction).once
      end
    end
  end

  RSpec::Matchers.define :be_responded do |response|
    match do |obj|
      message = double("message double (#{response})")
      obj = obj.to_e if defined? obj.to_e
      raise ArgumentError, 'Received object is not a double nor responds to .to_e' if obj.class != RSpec::Mocks::Double

      expect(obj).to(receive(:respond).with(response).ordered { message })
      message
    end
  end

  RSpec::Matchers.define :be_embeded do |embed|
    match do |obj|
      message = double("message double (#{embed})")
      obj = obj.to_e if defined? obj.to_e
      raise ArgumentError, 'Received object is not a double nor responds to .to_e' if obj.class != RSpec::Mocks::Double

      expect(obj).to(receive(:send_embed).with('', embed).ordered { message })
      message
    end
  end

  RSpec::Matchers.define :be_edited do |*edition|
    match do |obj|
      obj = obj.to_e if defined? obj.to_e
      raise ArgumentError, 'Received object is not a double nor responds to .to_e' if obj.class != RSpec::Mocks::Double

      expect(obj).to receive(:edit).with(*edition).ordered
    end
  end
end
