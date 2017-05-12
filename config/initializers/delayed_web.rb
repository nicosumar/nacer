# Tell Delayed::Web that we're using ActiveRecord as our backend.
Rails.application.config.to_prepare do
  Delayed::Web::Job.backend = 'active_record'
  Delayed::Worker.default_queue_name = 'default' 
  Delayed::Worker.sleep_delay = 60
  Delayed::Worker.destroy_failed_jobs = false
  Delayed::Job.attr_accessible :user_id, :proceso_de_sistema_id,:last_error
  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
  class Delayed::Job < ActiveRecord::Base
  
  	self.attr_protected if self.to_s == 'Delayed::Backend::ActiveRecord::Job'   #loads protected attributes for                                                                                        # ActiveRecord instance
  end

end
