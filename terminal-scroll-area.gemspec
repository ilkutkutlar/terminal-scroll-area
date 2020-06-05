Gem::Specification.new do |spec|
  spec.name = 'terminal-scroll-area'
  spec.version = '0.0.1'
  spec.authors = ['Ilkut Kutlar']
  spec.email = ['ilkutkutlar@gmail.com']
  spec.summary = ''
  spec.description = ''
  spec.homepage = 'https://github.com/ilkutkutlar/terminal-scroll-area'
  spec.license = 'MIT'

  spec.files = [
    'README.md',
    'lib/terminal-scroll-area.rb',
    'lib/terminal-scroll-area/scroll_area.rb',
  ]
  spec.require_paths = ['lib']
  
  spec.add_dependency 'tty-cursor', '~> 0.7.1'
  spec.add_dependency 'tty-reader', '~> 0.7.0'

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.82.0'
end
