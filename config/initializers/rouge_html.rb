require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTMLwithRouge < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
