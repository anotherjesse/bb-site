# == Schema Information
# Schema version: 72
#
# Table name: users
#
#  created_at           :datetime        
#  updated_at           :datetime        
#  id                   :integer         not null, primary key
#  password_hash        :string(40)      
#  email                :string(100)     
#  website              :string(100)     
#  display_name         :string(80)      
#  recover_password     :string(128)     
#  last_login_at        :datetime        
#  admin                :boolean         
#  posts_count          :integer         default(0)
#  scripts_count        :integer         default(0)
#  last_seen_at         :datetime        
#  login_key            :string(255)     
#  login_key_expires_at :datetime        
#  activated            :boolean         
#  bio                  :string(255)     
#  bio_html             :text            
#  deleted_at           :datetime        
#  comments_count       :integer         default(0)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  # has_many :comments, :dependent => :destroy, :order => 'comments.created_at'

  validates_presence_of     :display_name, :email, :password_hash
  validates_length_of       :password, :minimum => 5, :allow_nil => true
  validates_confirmation_of :password, :on => :create
  validates_uniqueness_of   :display_name, :email, :case_sensitive => false
  
  # first user becomes admin automatically
  before_create { |u| u.admin = u.activated = true if User.count == 0 }

  attr_reader :password
  attr_protected :admin, :created_at, :updated_at, :last_login_at, :activated

  # we allow false to be passed in so a failed login can check
  # for an inactive account to show a different error
  def self.authenticate(email, password, activated=true)
    find(:first, :conditions=>['lower(email) = ? and password_hash = ? and activated = ?', email.downcase, Digest::SHA1.hexdigest("#{$salt}--#{password}--"), activated])
  end

  def password=(value)
    return if value.blank?
    write_attribute :password_hash, Digest::SHA1.hexdigest("#{$salt}--#{value}--")
    @password = value
  end
  
  def reset_login_key!
    self.login_key = Digest::SHA1.hexdigest(Time.now.to_s + password_hash.to_s + rand(123456789).to_s).to_s
    # this is not currently honored
    self.login_key_expires_at = Time.now.utc+1.year
    save!
    login_key
  end

  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :email << :login_key << :login_key_expires_at << :password_hash
    super
  end

  def name
    self.display_name
  end

  def role
    return "Admin" if admin?
    "User"
  end

end
