# frozen_string_literal: true

# Scroll area which only shows a specific area of the content
# it holds at a time. Able to scroll area in all directions
# to show a different area of the content.
class ScrollArea
  attr_reader :start_x, :start_y, :content
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @start_x = 0
    @start_y = 0
    @content = ''
    update_content_dimensions
  end

  def render
    crop_text(@content, @start_x, @start_y, end_x, end_y)
  end

  def content=(new_content)
    @content = new_content
    update_content_dimensions
  end

  def add_string(string)
    self.content += string
  end

  def add_line(line)
    self.content += "#{line}\n"
  end

  def scroll_up
    return if @line_count < @height

    @start_y -= 1 if @start_y.positive?
  end

  def scroll_down
    return if @line_count < @height

    @start_y += 1 if end_y < (@line_count - 1)
  end

  def scroll_left
    return if @col_count < @width

    @start_x -= 1 if @start_x >= 1
  end

  def scroll_right
    return if @col_count < @width

    @start_x += 1 if end_x < (@col_count - 1)
  end

  def end_x
    @start_x + (@width - 1)
  end

  def end_y
    @start_y + (@height - 1)
  end

  private

  def update_content_dimensions
    @line_count = @content.split("\n").length
    @col_count = @content.split("\n").map(&:length).max
  end

  def crop_text(text, x_start, y_start, x_end, y_end)
    return '' if x_start >= @col_count || y_start >= @line_count

    lines = text.split("\n")
    lines = lines[y_start..y_end]
    lines = lines.map { |line| line[x_start..x_end] }
    lines.join("\n")
  end
end
