class BusinessProject < ActiveRecord::Base
  unloadable

  belongs_to :business
  belongs_to :project
end
