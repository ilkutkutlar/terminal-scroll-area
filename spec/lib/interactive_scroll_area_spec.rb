# frozen_string_literal: true

require_relative '../../lib/terminal-scroll-area/interactive_scroll_area'

# rubocop:disable Metrics/BlockLength
describe InteractiveScrollArea do
  subject { InteractiveScrollArea.new(10, 3) }
  let(:cursor_scroll_down_twice) { "\eD\eD" }
  let(:cursor_clear_three_lines) { "\e[2K\e[1G\e[1A\e[2K\e[1G\e[1A\e[2K\e[1G" }
  let(:cursor_save) { "\e7" }
  let(:cursor_restore) { "\e8" }

  before(:each) do
    subject.content = "Lorem ipsum dolor sit amet,\n"    \
                      "consectetur adipiscing elit.\n"   \
                      "Pellentesque dapibus \n"  \
                      "libero rhoncus, eu vol\n"    \
                      'augue euismod.'
  end

  describe '#scroll' do
    skip
  end

  describe '#content=' do
    it 'sets scroll area content' do
      subject.scroll_area.content = ''

      new_content = "test string\nanother line of test"
      subject.content = new_content
      expect(subject.scroll_area.content).to eq(new_content)
    end
  end

  describe '#add_string' do
    it 'adds string to scroll area content' do
      subject.scroll_area.content = ''

      subject.add_string('text')
      expect(subject.scroll_area.content).to eq('text')
    end
  end

  describe '#add_line' do
    it 'adds string and a newline to scroll area content' do
      subject.scroll_area.content = ''

      subject.add_line('text')
      expect(subject.scroll_area.content).to eq("text\n")
    end
  end

  describe '#keydown' do
    it 'scrolls scroll area down and draws new visible content in place' do
      subject.scroll_area.instance_variable_set(:@start_y, 0)
      subject.scroll_area.instance_variable_set(:@start_x, 0)

      expected = "#{cursor_scroll_down_twice}#{cursor_clear_three_lines}#{cursor_save}" \
                 "consectetu\nPellentesq\nlibero rho#{cursor_restore}"

      expect { subject.keydown(nil) }.to output(expected).to_stdout
      expect(subject.scroll_area.start_y).to eq(1)
    end
  end

  describe '#keyup' do
    it 'scrolls scroll area up and draws new visible content in place' do
      subject.scroll_area.instance_variable_set(:@start_y, 1)
      subject.scroll_area.instance_variable_set(:@start_x, 0)

      expected = "#{cursor_scroll_down_twice}#{cursor_clear_three_lines}#{cursor_save}" \
                 "Lorem ipsu\nconsectetu\nPellentesq#{cursor_restore}"

      expect { subject.keyup(nil) }.to output(expected).to_stdout
      expect(subject.scroll_area.start_y).to eq(0)
    end
  end

  describe '#keyleft' do
    it 'scrolls scroll area left and draws new visible content in place' do
      subject.scroll_area.instance_variable_set(:@start_y, 0)
      subject.scroll_area.instance_variable_set(:@start_x, 6)

      expected = "#{cursor_scroll_down_twice}#{cursor_clear_three_lines}#{cursor_save}" \
                 " ipsum dol\nctetur adi\nntesque da#{cursor_restore}"

      expect { subject.keyleft(nil) }.to output(expected).to_stdout
      expect(subject.scroll_area.start_x).to eq(5)
    end
  end

  describe '#keyright' do
    it 'scrolls scroll area right and draws new visible content in place' do
      subject.scroll_area.instance_variable_set(:@start_y, 0)
      subject.scroll_area.instance_variable_set(:@start_x, 6)

      expected = "#{cursor_scroll_down_twice}#{cursor_clear_three_lines}#{cursor_save}" \
                 "psum dolor\netur adipi\nesque dapi#{cursor_restore}"

      expect { subject.keyright(nil) }.to output(expected).to_stdout
      expect(subject.scroll_area.start_x).to eq(7)
    end
  end
end
# rubocop:enable Metrics/BlockLength
