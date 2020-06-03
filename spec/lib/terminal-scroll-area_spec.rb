# frozen_string_literal: true
require_relative '../../lib/terminal-scroll-area'

describe ScrollArea do
  subject { ScrollArea.new(5, 2) }

  before(:each) do
    subject.text = "Lorem ipsum dolor sit amet,\n"    \
                   "consectetur adipiscing elit.\n"   \
                   "Pellentesque dapibus dui eget\n"  \
                   "libero rhoncus, eu volutpat\n"    \
                   'augue euismod.'
  end

  describe '#render' do
    it 'crops content into given dimensions' do
      subject.instance_variable_set(:@start_y, 0)
      subject.instance_variable_set(:@start_x, 0)
      expected = "Lorem\n" \
                 "conse"
      expect(subject.render).to eq(expected)
    end

    it 'shows lines from `start_y` and columns from `start_x`, cropped to dimensions' do
      subject.instance_variable_set(:@start_y, 1)
      subject.instance_variable_set(:@start_x, 1)
      expected = "onsec\n" \
                 "ellen"
      expect(subject.render).to eq(expected)

    end
  end

  describe '#add_string' do
    it 'adds string to scroll area content' do
      subject.text = ""

      subject.add_string("text")
      expect(subject.text).to eq("text")
    end
  end

  describe '#add_line' do
    it 'adds string and a newline to scroll area content' do
      subject.text = ""

      subject.add_line("text")
      expect(subject.text).to eq("text\n")
    end
  end

  describe '#scroll_up' do
    it 'decreases vertical content start position to show more lines at the top' do
      subject.instance_variable_set(:@start_y, 4)
      subject.scroll_up
      expect(subject.start_y).to eq(3)
    end

    it 'does nothing if current position is topmost line of content' do
      subject.instance_variable_set(:@start_y, 0)
      subject.scroll_up
      expect(subject.start_y).to eq(0)
    end

    it 'does nothing if content line count is less than height' do
      # TODO: Kind of redundant, as start_y will always be 0, and
      # TODO: this behaviour will always be covered by > 0 check anyway!
      subject.text = "Lorem ipsum dolor sit amet,\n"  \
                     "consectetur adipiscing elit."
      subject.height = 5
      subject.instance_variable_set(:@start_y, 1)
      subject.scroll_up
      expect(subject.start_y).to eq(1)
    end
  end

  describe '#scroll_down' do
    it 'increases vertical content start position to show more lines at the bottom' do
      subject.instance_variable_set(:@start_y, 3)
      subject.scroll_down
      expect(subject.start_y).to eq(4)
    end

    it 'does nothing if current position is bottommost line of content' do
      subject.instance_variable_set(:@start_y, 4)
      subject.scroll_down
      expect(subject.start_y).to eq(4)
    end

    it 'does nothing if content line count is less than height' do
      subject.text = "Lorem ipsum dolor sit amet,\n"  \
                     "consectetur adipiscing elit."
      subject.height = 5
      subject.instance_variable_set(:@start_y, 1)
      subject.scroll_down
      expect(subject.start_y).to eq(1)
    end
  end

  describe '#scroll_left' do
    it 'decreases horizontal content start position to show more columns on the left' do
      subject.instance_variable_set(:@start_x, 4)
      subject.scroll_left
      expect(subject.start_x).to eq(3)
    end

    it 'does nothing if current position is leftmost column of content' do
      subject.instance_variable_set(:@start_x, 0)
      subject.scroll_left
      expect(subject.start_x).to eq(0)
    end
  end

  describe '#scroll_right' do
    it 'increases horizontal content start position to show more columns on the right' do
      subject.instance_variable_set(:@start_x, 3)
      subject.scroll_right
      expect(subject.start_x).to eq(4)
    end

    it 'does nothing if current position is rightmost column of content' do
      max_col_length = 29
      subject.instance_variable_set(:@start_x, max_col_length - 1)
      subject.scroll_right
      expect(subject.start_x).to eq(max_col_length - 1)
    end
  end
end
