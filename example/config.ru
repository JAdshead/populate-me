$:.unshift File.expand_path('../../lib', __FILE__)
require 'populate_me'
require 'populate_me/active_record_proxy'

# Models ##########

class BlogPost < ActiveRecord 
  include PopulateMe::ActiveRecordProxy

end

# require 'populate_me/document'
# class BlogPost
#   include PopulateMe::Document
#   field :title
#   field :content, type: :text
#   # field :authors, type: :list
#   field :published, type: :boolean
#   def validate
#     # error_on(:content,'Cannot be blank') if PopulateMe::Utils.blank?(self.content)
#   end
# end
# class BlogPost::Author
#   include PopulateMe::Document
#   field :name
# end

# Admin ##########

require "populate_me/admin"
class Admin < PopulateMe::Admin
  enable :sessions
  set :menu, [ 
    ['Blog Posts', '/list/blog-post'],
  ]
end

run Admin

