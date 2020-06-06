# frozen_string_literal: true

require 'tty-reader'
require 'tty-cursor'
require_relative 'scroll_area'

# Interactice scroll area which scrolls and reprints
# the content in response to user pressing arrow keys.
class InteractiveScrollArea
  attr_reader :content
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height

    @scroll = ScrollArea.new(@width, @height)

    @reader = TTY::Reader.new(interrupt: :exit)
    @reader.subscribe(self)
  end

  def scroll
    print_in_place(@scroll.render)
    TTY::Cursor.invisible do
      loop do
        @reader.read_keypress
      end
    end
  end

  def content=(new_content)
    @scroll.content = new_content
  end

  def add_string(string)
    self.content += string
  end

  def add_line(line)
    self.content += "#{line}\n"
  end

  def keydown(_event)
    @scroll.scroll_down
    print_in_place(@scroll.render)
  end

  def keyup(_event)
    @scroll.scroll_up
    print_in_place(@scroll.render)
  end

  def keyright(_event)
    @scroll.scroll_right
    print_in_place(@scroll.render)
  end

  def keyleft(_event)
    @scroll.scroll_left
    print_in_place(@scroll.render)
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
