class Business < ActiveRecord::Base
  unloadable

  belongs_to :customer
  
  def self.status_to_label status
    statuses.each do |sts|
      if sts[1] == status
        return sts[0]
      end
    end
    return nil
  end

  def self.statuses
    [
      [l(:business_status_approached), 'approached'],
      [l(:business_status_accepted), 'accepted'],
      [l(:business_status_failure), 'failure'],
      [l(:business_status_developing), 'developing'],
      [l(:business_status_delivered), 'delivered'],
      [l(:business_status_closed), 'closed'],
    ]
  end
end
