class BusinessesController < ApplicationController
  unloadable
  before_filter :require_admin
  before_filter :find_business, :except => [:index, :new, :actual_cost_update]

  layout 'main'

  def index
    @maxBusinesses = 0;
    @customers = Customer.find(:all)
    @customers.each do |customer|
      if customer.businesses.size > @maxBusinesses
        @maxBusinesses = customer.businesses.size
      end
    end
  end


  def new
    @business = Business.new(params[:business])
    @customer_id = params[:customer_id]
    if request.post?
      @business.customer_id = @customer_id
      @business.actual_cost = 0
      @business.actual_hours = 0
      if @business.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'businesses'
      end
    end
  end


  def edit
    @customer_id = params[:customer_id]
    if request.post?
      @business.attributes = params[:business]
      @business.customer_id = @customer_id
      if @business.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => 'businesses'
      end
    end
    rescue ActiveRecord::StaleObjectError
      flash.now[:error] = l(:notice_locking_conflict)
  end


  def destroy
    @business.destroy
    redirect_to :controller => 'businesses'
  end


  def actual_cost_update
    businesses = Business.find(:all)

    if businesses.blank?
      flash[:notice] = l(:label_no_data)
    else
      businesses.each do |business|
        actual_cost = 0
        actual_hours = 0
        costs = {}

        user_costs = UserCostByHour.find(:all)
        user_costs.each do |user_cost|
          costs[user_cost.user_id] = user_cost.cost_by_hour
        end unless user_costs.blank?
        costs[UserCostByHour::default_id] = UserCostByHour.get_default.cost_by_hour if costs[UserCostByHour::default_id].blank?

        business_projects = BusinessProject.find(:all, :conditions => {:business_id => business.id})
        business_projects.each do |business_project|
          entries = TimeEntry.find(:all, :conditions => {:project_id => business_project.project_id})
          entries.each do |entry|
            if costs[entry.user_id].blank?
              actual_cost += entry.hours * costs[UserCostByHour::default_id]
              actual_hours += entry.hours
            else
              actual_cost += entry.hours * costs[entry.user_id]
              actual_hours += entry.hours
            end
          end unless entries.blank?
        end
        business.actual_cost = actual_cost
        business.actual_hours = actual_hours
      end

      result = true
      ActiveRecord::Base::transaction() do
        businesses.each do |business|
          if !business.save
            result = false
            raise ActiveRecord::RecordInvalid::exception(:error_actual_cost_update)
          end
        end
      end

      if result
        flash[:notice] = l(:notice_successful_update)
      else
        flash[:notice] = l(:error_actual_cost_update)
      end
    end

    rescue ActiveRecord::StaleObjectError
      flash.now[:error] = l(:notice_locking_conflict)
    ensure
      redirect_to :controller => 'businesses'
  end


  private
  def find_business
    @business = Business.find_by_id(params[:id])
    render_404 unless @business
  end

end
