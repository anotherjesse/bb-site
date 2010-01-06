# == Schema Information
# Schema version: 16
#
# Table name: checks
#
#  id             :integer(11)     not null, primary key
#  isbn           :string(255)     
#  last_tested_at :datetime        
#  last_passed_at :datetime        
#  library_id     :integer(11)     
#  passing        :boolean(1)      
#  expects        :boolean(1)      
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Check < ActiveRecord::Base
  belongs_to :library
end
