# Terminal Scroll Area

[![Gem Version](https://badge.fury.io/rb/terminal-scroll-area.svg)](https://badge.fury.io/rb/terminal-scroll-area)

<img alt="Gif showing usage" src="https://raw.githubusercontent.com/ilkutkutlar/terminal-scroll-area/main/usage.gif" width=50%>

This gem lets the user display large text on terminal by creating a scroll area in which only a specified portion of the text is displayed at a time. This portion can be moved to reveal other parts of the text, analogous to a GUI scroll area, or a more general purpose pager. This gem is useful when your program needs to display a large amount of text that may not fit into the screen.

The `ScrollArea` class, which is not interactive, does not use Curses or a similar screen management library. The `InteractiveScrollArea` class does not rely on the Curses library and instead uses the [TTY toolkit](https://github.com/piotrmurach/tty), which has cross platform support and support for many types of terminals/terminal emulators. Therefore this gem should also have the same level of support.

# Installation

```rb
gem install 'terminal-scroll-area'
```

or add it to your project's `Gemfile`:

```rb
gem 'terminal-scroll-area'
```

# Usage

## `ScrollArea` class

- Simple scroll area which lets you programmatically scroll the content in all directions.
- Initialise:

```rb
# Only display 5 lines at a time with
# 5 characters in each line.
width = 5
height = 5
scroll = ScrollArea.new(width, height)
```

- Set the content that the scroll area will contain:

```rb
# Set content all at once:
scroll.content = "some text"

# Or use add_string/add_line:
scroll.add_string("some string")

# Same as add_string, but adds a newline
# after the string
scroll.add_line("some line")
```

- Render scroll area to get the portion of the entire content which is in view:

```rb
# Render and print the currently visible
# portion of the text.
print(scroll.render)
```

- Scroll in all directions to reveal other portions:

```rb
# also available: 
# - scroll_down
# - scroll_left
# - scroll_right
scroll.scroll_up
```

- Scroll area lets you access some values you may find useful:

```rb
# The starting coordinates of the window which is displayed.
scroll.start_x
scroll.start_y

# The ending coordinates of the window which is displayed.
scroll.end_x
scroll.end_y
```

## `InteractiveScrollArea`

- Regular `ScrollArea` lets you scroll the content with `scroll_<direction>` methods. `InteractiveScrollArea` displays an interactive scroll area where the user can use arrow keys to control scrolling of the content (e.g. up arrow scrolls up, etc.).
- This class will automatically print a new rendering of the area after user has triggered a scroll event by pressing a key. The previously printed rendering is removed and the updated rendering is printed in the same area, thereby giving the feeling of interactivity.

```rb
width = 5
height = 5
interactive = InteractiveScrollArea(width, height)

# add_string and add_line are also available.
interactive.content = "some text"

# Starts a loop, allowing user to use arrow keys to
# scroll the content. Press Ctrl + C to exit.
interactive.scroll
```
