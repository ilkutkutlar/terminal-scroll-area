# frozen_string_literal: true

require 'tty-reader'

class ScrollArea
  attr_reader :start_x, :start_y
  attr_accessor :text, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @start_x = 0
    @start_y = 0
    @text = ''
  end

  def render
    end_x = (@start_x + @width) - 1
    end_y = (@start_y + @height) - 1
    crop_text(@text, @start_x, @start_y, end_x, end_y)
  end

  def add_line(line)
    @text += "#{line}\n"
  end

  def add_string(string)
    @text += string
  end

  def scroll_up
    return if line_count < @height

    @start_y -= 1 if @start_y > 0
  end

  def scroll_down
    return if line_count < @height

    end_y = @start_y + (@height - 1)
    @start_y += 1 if end_y < (line_count - 1)
  end

  def scroll_left
    return if col_count < @width

    @start_x -= 1 if @start_x >= 1
  end

  def scroll_right
    return if col_count < @width

    end_x = @start_x + (@width - 1)
    @start_x += 1 if end_x < (col_count - 1)
  end

  private

  def visible_line_count(start_line)
    line_count - start_line
  end

  def line_count
    @text.split("\n").length
  end

  def col_count
    @text.split("\n").map(&:length).max
  end

  def crop_text(text, x_start, y_start, x_end, y_end)
    lines = text.split("\n")

    return '' if x_start >= lines.first.length || \
                 y_start >= lines.length

    lines = lines[y_start..y_end]
    lines = lines.map { |line| line[x_start..x_end] }
    lines.join("\n")
  end
end
