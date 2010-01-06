# == Schema Information
# Schema version: 16
#
# Table name: events
#
#  id          :integer(11)     not null, primary key
#  library_id  :integer(11)     
#  title       :string(255)     
#  description :text            
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Event < ActiveRecord::Base
end
