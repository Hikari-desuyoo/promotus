require 'rails_helper'

RSpec.describe PrettyTree::TextFormatter do
  context "#new" do
    it 'creates empty formatter' do
      text = PrettyTree::TextFormatter.new
      expect(text.lines).to be_empty
    end
  end

  context "#last_line_index" do
    it 'returns last lines index' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'ab c'
      text.lines << 'd4567'
      text.lines << ' 8     '
      expect(text.last_line_index).to eq(2)
    end
  end

  context "#add_line" do
    it 'adds line to formatter' do
      text = PrettyTree::TextFormatter.new
      text.add_line('testing')
      expect(text.lines).to eq(%w(testing))
    end

    it 'adds line to formatter on order' do
      text = PrettyTree::TextFormatter.new
      text.add_line('testing1')
      text.add_line('testing2')
      expect(text.lines).to eq(%w(testing1 testing2))
    end
  end

  context "#render" do
    it 'returns string joined by newlines' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'ab c'
      text.lines << 'd4567'
      text.lines << ' 8     '
      expect(text.render).to eq("ab c\nd4567\n 8     ")
    end

    it 'returns empty string when empty formatter' do
      text = PrettyTree::TextFormatter.new
      expect(text.render).to eq('')
    end
  end

  context "#indent_line" do
    it 'indents line accordingly' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'abc'
      text.lines << 'defg'
      text.lines << 'hijkl mnop'
      text.indent_line(1, 10)

      expect(text.lines).to eq(
        [
          'abc',
          '          defg',
          'hijkl mnop'
        ]
      )
    end
  end

  context '#add_text' do
    it 'adds text to target line' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'abc'
      text.lines << 'defg'
      text.lines << 'hijkl mnop'
      text.add_text(2, 'abacaxi')

      expect(text.lines).to eq(
        [
          'abc',
          'defg',
          'hijkl mnopabacaxi'
        ]
      )
    end
  end

  context '#insert_on_line' do
    context 'inserts extra text within line' do
      it 'sucessfully (normal case)' do
        text = PrettyTree::TextFormatter.new
        text.lines << 'abc'
        text.lines << 'defg'
        text.lines << 'hijkl mnop'
        text.insert_on_line(2, 6, '!!')
        expect(text.lines).to eq(
          [
            'abc',
            'defg',
            'hijkl !!op'
          ]
        )
      end

      it 'even if inserted text is outside lines length' do
        text = PrettyTree::TextFormatter.new
        text.lines << 'abc'
        text.lines << 'defg'
        text.lines << 'hijkl mnop'
        text.insert_on_line(1, 6, 'abobrinha')
        expect(text.lines).to eq(
          [
            'abc',
            'defg  abobrinha',
            'hijkl mnop'
          ]
        )
      end

      it 'even if inserted text is  halfway outside lines length' do
        text = PrettyTree::TextFormatter.new
        text.lines << 'abc'
        text.lines << 'defg'
        text.lines << 'hijkl mnop'
        text.insert_on_line(2, 6, 'abobrinha')
        expect(text.lines).to eq(
          [
            'abc',
            'defg',
            'hijkl abobrinha'
          ]
        )
      end
    end
  end

  context '#normalize' do
    it 'does nothing if line length is equal or greater than desired size' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'abc'
      text.lines << 'defg'
      text.lines << 'hijkl mnop'
      text.normalize(1, 2, '*')

      expect(text.lines).to eq(
        [
          'abc',
          'defg',
          'hijkl mnop'
        ]
      )
    end

    it 'adds characters until target line have desired size' do
      text = PrettyTree::TextFormatter.new
      text.lines << 'abc'
      text.lines << 'defg'
      text.lines << 'hijkl mnop'
      text.normalize(1, 7, '*')

      expect(text.lines).to eq(
        [
          'abc',
          'defg***',
          'hijkl mnop'
        ]
      )
    end
  end
end

