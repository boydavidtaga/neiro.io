require 'jekyll-assets'
require 'jekyll-assets/compass'
require 'bundler/setup'

Bundler.require(:default, 'development')

if defined?(RailsAssets)
  RailsAssets.load_paths.each do |path|
    settings.sprockets.append_path(path)
  end
end
