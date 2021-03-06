# frozen_string_literal: true

require_relative '../../lib/terminal-scroll-area/scroll_area'

# rubocop:disable Metrics/BlockLength
describe ScrollArea do
  subject { ScrollArea.new(5, 2) }

  before(:each) do
    subject.content = "Lorem ipsum dolor sit amet,\n"    \
                      "consectetur adipiscing elit.\n"   \
                      "Pellentesque dapibus \n"  \
                      "libero rhoncus, eu vol\n"    \
                      'augue euismod.'
  end

  describe '#render' do
    it 'crops content into given dimensions' do
      subject.instance_variable_set(:@start_y, 0)
      subject.instance_variable_set(:@start_x, 0)
      expected = "Lorem\n" \
                 'conse'
      expect(subject.render).to eq(expected)
    end

    it 'shows lines from `start_y` and columns from `start_x`, cropped to dimensions' do
      subject.instance_variable_set(:@start_y, 1)
      subject.instance_variable_set(:@start_x, 1)
      expected = "onsec\n" \
                 'ellen'
      expect(subject.render).to eq(expected)
    end

    it 'shows a blank line if `start_x` is too large for the line to be visible' do
      # e.g. if start_y is 3, these two lines are visible:
      # libero rhoncus, eu volutpat
      # augue euismod.
      #
      # if start_x is 15, then lines are cropped to this:
      #
      # libero rhoncus,| eu v|ol
      # augue euismod. |     |
      #
      # and expected output is " eu v\n"
      subject.instance_variable_set(:@start_y, 3)
      subject.instance_variable_set(:@start_x, 15)
      expected = " eu v\n"
      expect(subject.render).to eq(expected)

      subject.height = 3
      subject.instance_variable_set(:@start_y, 2)
      subject.instance_variable_set(:@start_x, 25)
      expected = "\n\n"
      expect(subject.render).to eq(expected)
    end
  end

  describe '#content=' do
    it 'sets content and updates content dimensions' do
      new_content = "test string\nanother line of test"
      subject.content = new_content

      expect(subject.content).to eq(new_content)
      expect(subject.instance_variable_get(:@line_count)).to eq(2)
      expect(subject.instance_variable_get(:@col_count)).to eq(20)
    end
  end

  describe '#add_string' do
    it 'adds string to scroll area content and updates dimensions to match new content' do
      subject.content = ''

      subject.add_string('text')
      expect(subject.content).to eq('text')
      expect(subject.instance_variable_get(:@line_count)).to eq(1)
      expect(subject.instance_variable_get(:@col_count)).to eq(4)
    end
  end

  describe '#add_line' do
    it 'adds string and newline to scroll area content, updates dimensions to match new content' do
      subject.content = ''

      subject.add_line('text')
      expect(subject.content).to eq("text\n")
      expect(subject.instance_variable_get(:@line_count)).to eq(1)
      expect(subject.instance_variable_get(:@col_count)).to eq(4)
    end
  end

  describe '#scroll_up' do
    it 'decreases vertical content start position to show more lines at the top' do
      subject.instance_variable_set(:@start_y, 4)
      subject.scroll_up
      expect(subject.start_y).to eq(3)
    end

    it 'does nothing if content line count is less than height' do
      subject.height = 10
      subject.instance_variable_set(:@start_y, 0)
      subject.scroll_up
      expect(subject.start_y).to eq(0)
    end

    it 'does nothing if there are no more lines left at the top to show' do
      # in other words, if current position is topmost line of content
      subject.instance_variable_set(:@start_y, 0)
      subject.scroll_up
      expect(subject.start_y).to eq(0)
    end
  end

  describe '#scroll_down' do
    it 'increases vertical content start position to show more lines at the bottom' do
      subject.instance_variable_set(:@start_y, 2)
      subject.scroll_down
      expect(subject.start_y).to eq(3)
    end

    it 'does nothing if content line count is less than height' do
      subject.height = 10
      subject.instance_variable_set(:@start_y, 0)
      subject.scroll_down
      expect(subject.start_y).to eq(0)
    end

    it 'does nothing if there are no more lines left at the bottom to show' do
      # subject's height is 2.
      # subject's content's line count is 5.
      # If start_y is 3, this is
      # the content shown (bottom 2 lines):
      #
      # libero rhoncus, eu volutpat
      # augue euismod.
      #
      # Since we are seeing bottom 2 lines,
      # scrolling down further doesn't show
      # any more lines, so start_y should
      # remain the same in this scenario.
      subject.instance_variable_set(:@start_y, 3)
      subject.scroll_down
      expect(subject.start_y).to eq(3)
    end
  end

  describe '#scroll_left' do
    it 'decreases horizontal content start position to show more columns on the left' do
      subject.instance_variable_set(:@start_x, 4)
      subject.scroll_left
      expect(subject.start_x).to eq(3)
    end

    it 'increases horizontal content start position to show more columns on the right' do
      # in other words if current position is leftmost column of content
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

    it 'does nothing if there are no more columns left to the right to show' do
      # width is 5, therefore at start_x = 24,
      # this is how the page looks like:
      #
      # |et,  |
      # |lit. |
      # | eget|
      # |pat  |
      # |     |
      #
      # This is the end of content, i.e. the last page,
      # so scrolling right won't show more content.
      # Therefore scrolling right should do nothing

      max_col_index = 28
      last_page_start_x = max_col_index - 4

      subject.instance_variable_set(:@start_x, last_page_start_x)
      subject.scroll_right
      expect(subject.start_x).to eq(last_page_start_x)
    end
  end
  describe '#end_x' do
    it 'returns the zero-based column number of the last character displayed' do
      subject.instance_variable_set(:@start_x, 4)
      expect(subject.end_x).to eq(8)
    end
  end

  describe '#end_y' do
    it 'returns the zero-based line number of the last line displayed' do
      subject.instance_variable_set(:@start_y, 4)
      expect(subject.end_y).to eq(5)
    end
  end
end
# rubocop:enable Metrics/BlockLength
