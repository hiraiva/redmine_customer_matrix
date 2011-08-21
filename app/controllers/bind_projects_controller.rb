class BindProjectsController < ApplicationController
  unloadable
  before_filter :require_admin
  before_filter :find_business

  layout 'main'

  def index
    if request.post?
      result = true
      add = [];
      remove = []; 
      @projects.each do |project|
        if @bindeds[project.id].blank?
          if params[:binding][project.id.to_s]
            add << project.id
          end
        else
          unless params[:binding][project.id.to_s]
            remove << project.id
          end
        end
      end

      ActiveRecord::Base::transaction() do
        begin
          remove.each do |id|
            BusinessProject.destroy_all({:project_id => id})
          end
          add.each do |id|
            BusinessProject.create({:business_id => params[:id], :project_id => id})
          end
        rescue Error => error
          result = false;
          raise error
        end
      end

      if result
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => 'bind_projects'
      else 
        flash[:notice] = l(:error_costs_update)
      end
    end
  end

  private
  def find_business
    @business = Business.find_by_id(params[:id])
    render_404 unless @business
    @projects = Project.find(:all)
    @bindeds = {}
    bindeds = BusinessProject.find(:all, :conditions => {:business_id => params[:id]})
    bindeds.each do |binded|
      @bindeds[binded.project_id] = binded;
    end unless bindeds.blank?
  end
  
end
