class CustomersController < ApplicationController
  unloadable
  before_filter :require_admin
  before_filter :find_customer, :except => [:new]

  layout 'main'

  def new
    @customer = Customer.new(params[:customer])
    if request.post?
      if @customer.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'businesses',  :action => 'index'
      end
    end
  end


  def edit
    if request.post?
      @customer.attributes = params[:customer]
      if @customer.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => 'businesses',  :action => 'index'
      end
    end
    rescue ActiveRecord::StaleObjectError
      flash.now[:error] = l(:notice_locking_conflict)
  end


  def destroy
    @customer.destroy
    redirect_to :controller => 'businesses',  :action => 'index'
  end

  
  private
  def find_customer
    @customer = Customer.find_by_id(params[:id])
    render_404 unless @customer
  end

end
