require 'redmine'

Redmine::Plugin.register :redmine_customer_matrix do
  name 'Customer Matrix plugin'
  author 'Jiro Hiraiwa'
  description 'Customer Matrix plugin'
  version '0.0.1'
  url 'https://github.com/hiraiva'
  author_url 'https://github.com/hiraiva'

  menu :top_menu, :customer_matrix, { :controller => 'businesses', :action => 'index' }, :caption => :label_customer_matrix, :last => true
end
