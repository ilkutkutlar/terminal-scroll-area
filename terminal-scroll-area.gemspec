Gem::Specification.new do |spec|
  spec.name = 'terminal-scroll-area'
  spec.version = '0.0.1'
  spec.authors = ['Ilkut Kutlar']
  spec.email = ['ilkutkutlar@gmail.com']
  spec.summary = 'Scroll area to display large text on terminal'
  spec.description = 'This gem lets user display large text on terminal by creating a scroll area in which only a specified portion of the text is displayed at a time. This portion can be moved to reveal other parts of the text, analogous to a GUI scroll area.'
  spec.homepage = 'https://github.com/ilkutkutlar/terminal-scroll-area'
  spec.license = 'MIT'

  spec.files = [
    'README.md',
    'lib/terminal-scroll-area.rb',
    'lib/terminal-scroll-area/scroll_area.rb',
    'lib/terminal-scroll-area/interactive_scroll_area.rb',
  ]
  spec.require_paths = ['lib']
  
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'tty-cursor', '~> 0.7.1'
  spec.add_dependency 'tty-reader', '~> 0.7.0'

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.82.0'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
end
