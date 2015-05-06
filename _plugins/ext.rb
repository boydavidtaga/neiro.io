require 'jekyll-assets'
require 'jekyll-assets/compass'
require 'jekyll/tagging'
require 'susy'
require 'bundler/setup'

Bundler.require(:default, 'development')

if defined?(RailsAssets)
  RailsAssets.load_paths.each do |path|
    Sprockets.append_path path
  end
end
