class Customer < ActiveRecord::Base
  unloadable

  has_many :businesses
end
