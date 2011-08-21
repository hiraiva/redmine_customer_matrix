class UserCostsController < ApplicationController
  unloadable
  before_filter :require_admin
  before_filter :find_user_costs

  layout 'main'
  
  def index
    if request.post? && params[:costs].is_a?(Hash)
      result = true
      ActiveRecord::Base::transaction() do
        params[:costs].each do |key, cost|
          key = key.to_i
          if cost[:cost_by_hour].blank?
            @costs[key].user_id = cost[:user_id].to_i
            @costs[key].cost_by_hour = nil
          else
            @costs[key].user_id = cost[:user_id].to_i
            @costs[key].cost_by_hour = cost[:cost_by_hour].to_i
          end

          if @costs[key].id.nil?
            unless @costs[key].save
              result = false
              raise ActiveRecord::RecordInvalid::exception(:error_costs_update)
            end unless @costs[key].cost_by_hour.nil?
          else
            if @costs[key].cost_by_hour.nil?
              unless @costs[key].destroy
                result = false
                raise ActiveRecord::RecordInvalid::exception(:error_costs_update)
              end if key.to_i != UserCostByHour::default_id
            else
              unless @costs[key].save
                result = false
                raise ActiveRecord::RecordInvalid::exception(:error_costs_update)
              end
            end
          end
        end
      end

      if result
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => 'user_costs'
      else 
        flash[:notice] = l(:error_costs_update)
      end
    end
    rescue ActiveRecord::StaleObjectError
      flash.now[:error] = l(:notice_locking_conflict)
  end

  
  private
  def find_user_costs
    @costs = {}
    @users = User.find(:all)
    @users.each do|user|
      key = user.id
      @costs[key] = UserCostByHour.find_by_user_id(user.id)
      if @costs[key].nil?
        @costs[key] = UserCostByHour.new
      end
      @costs[key].cost_by_month = (@costs[key].cost_by_hour.nil?) ? nil : @costs[key].cost_by_hour * UserCostByHour::working_hours * UserCostByHour::working_days  
    end unless @users.blank?

    @costs[UserCostByHour::default_id] = UserCostByHour.find_by_user_id(UserCostByHour::default_id)
    if @costs[UserCostByHour::default_id].blank?
      @costs[UserCostByHour::default_id] = UserCostByHour.get_default
    else
      @costs[UserCostByHour::default_id].cost_by_month = (@costs[UserCostByHour::default_id].cost_by_hour.nil?) ? nil : @costs[UserCostByHour::default_id].cost_by_hour * UserCostByHour::working_hours * UserCostByHour::working_days  
    end
  end

end
