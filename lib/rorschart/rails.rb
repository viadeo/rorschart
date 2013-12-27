if Rails.version >= "3.1"
  require "rorschart/engine"
else
  ActionView::Base.send :include, Rorschart::Helper
end
