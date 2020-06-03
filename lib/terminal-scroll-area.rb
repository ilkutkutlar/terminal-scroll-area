require 'tty-reader'

class ScrollArea
  attr_reader :start_x, :start_y
  attr_accessor :text, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @start_x = 0
    @start_y = 0
    @text = ""
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

  def scroll_up(by = 1)
    return if line_count < @height

    @start_y -= by if @start_y >= by
  end

  def scroll_down(by = 1)
    return if line_count < @height

    @start_y += by if @start_y < line_count - by \
                      && visible_line_count(@start_y + by) >= @height
  end

  def scroll_left(by = 1)
    @start_x -= by if @start_x >= by
  end

  def scroll_right(by = 1)
    @start_x += by if @start_x < col_count - by
  end

  private

  def visible_line_count(start_line)
    line_count - start_line
  end

  def line_count
    @text.split("\n").length
  end

  def col_count
    @text.split("\n").map {|line| line.length}.sort.last
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


#scroll = ScrollArea.new(20, 3)

#scroll.text = "Lorem ipsum dolor sit amet,\n"    \
#  "consectetur adipiscing elit.\n"   \
#  "Pellentesque dapibus dui eget\n"  \
#  "libero rhoncus, eu volutpat\n"    \
#  "augue euismod.\n"

#reader = TTY::Reader.new(interrupt: :exit)

#reader.on(:keydown) {
#  print(TTY::Cursor.clear_screen_down)
#  scroll.scroll_down
#  r = scroll.render
#  print(r)
#  print(TTY::Cursor.column(0))
#  print(TTY::Cursor.up(2))
#  #print(TTY::Cursor.up(r.split("\n").length) + TTY::Cursor.column(0))
#}

#reader.on(:keyup) {
#  print(TTY::Cursor.clear_screen_down)
#  scroll.scroll_up
#  r = scroll.render
#  print(r)
#  print(TTY::Cursor.column(0))
#  print(TTY::Cursor.up(2))
#  #print(TTY::Cursor.up(r.split("\n").length) + TTY::Cursor.column(0))
#}

#while true
#  reader.read_keypress
#end


#print(scroll.render)
