# == Schema Information
# Schema version: 16
#
# Table name: books
#
#  id         :integer(11)     not null, primary key
#  title      :string(255)     
#  author     :string(255)     
#  image_url  :string(255)     
#  isbn       :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Book < ActiveRecord::Base
end
