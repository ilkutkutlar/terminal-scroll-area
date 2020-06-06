# frozen_string_literal: true

require 'tty-reader'
require 'tty-cursor'
require_relative 'scroll_area'

# Interactice scroll area which scrolls and reprints
# the content in response to user pressing arrow keys.
class InteractiveScrollArea
  attr_reader :content
  attr_accessor :width, :height, :scroll_area

  def initialize(width, height)
    @width = width
    @height = height

    @scroll_area = ScrollArea.new(@width, @height)

    @reader = TTY::Reader.new(interrupt: :exit)
    @reader.subscribe(self)
  end

  def scroll
    print_in_place(@scroll_area.render)
    TTY::Cursor.invisible do
      loop do
        @reader.read_keypress
      end
    end
  end

  def content=(new_content)
    @scroll_area.content = new_content
  end

  def add_string(string)
    @scroll_area.add_string(string)
  end

  def add_line(line)
    @scroll_area.add_line(line)
  end

  def keydown(_event)
    @scroll_area.scroll_down
    print_in_place(@scroll_area.render)
  end

  def keyup(_event)
    @scroll_area.scroll_up
    print_in_place(@scroll_area.render)
  end

  def keyright(_event)
    @scroll_area.scroll_right
    print_in_place(@scroll_area.render)
  end

  def keyleft(_event)
    @scroll_area.scroll_left
    print_in_place(@scroll_area.render)
  end

  private

  def print_in_place(text)
    cursor = TTY::Cursor

    # Scrolling down is needed if there are less lines under
    # the terminal prompt than the content height. Or else, clearing
    # lines upwards by the content height will remove the prompt as well.
    in_place = TTY::Cursor.scroll_down * (@height - 1)
    in_place << cursor.clear_lines(@height, :up)
    in_place << cursor.save
    in_place << text
    in_place << cursor.restore

    print(in_place)
  end
end
