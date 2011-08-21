class UserCostByHour < ActiveRecord::Base
  unloadable

  cattr_accessor :default_id, :working_days, :working_hours
  attr_accessor :cost_by_month

  @@default_id = -1
  @@working_days = 20
  @@working_hours = 8

  @cost_by_month = nil

  def get_default
    UserCostByHour.new({
        :cost_by_month => l(:default_user_cost_by_month),
        :cost_by_hour => (l(:default_user_cost_by_month) / @@working_days / @@working_hours).round,
        :user_id => @@default_id,
        :updated_at => nil,
    })
  end
end
