# == Schema Information
# Schema version: 16
#
# Table name: libraries
#
#  id               :integer(11)     not null, primary key
#  name             :string(255)     
#  location         :string(255)     
#  bookmarklet      :text            
#  opac             :string(255)     
#  full_address     :string(255)     
#  country_code     :string(255)     
#  state            :string(255)     
#  city             :string(255)     
#  lat              :float           
#  lng              :float           
#  isbn_link        :string(255)     
#  collection_info  :text            
#  hours            :text            
#  catalog_url      :text            
#  special_features :text            
#  contacts         :text            
#  historical_info  :text            
#  source           :string(255)     
#  match_isbn       :boolean(1)      
#  match_positive   :string(255)     
#  match_negative   :string(255)     
#

class Library < ActiveRecord::Base
  acts_as_mappable
  
  BOOKMARKLET_BASE = %q(javascript:var%20re=/([\/-]|is[bs]n=)(\d{7,9}[\dX])/i;if(re.test(location.href)==true){var%20isbn=RegExp.$2;void(win=window.open(LIBRARY_ISBN_LINK,'LibraryLookup','scrollbars=1,resizable=1,width=575,height=500'))};)

  has_many :checks
  
  before_create :geocode_address

  def update_url
    "http://librari.us/libraries/#{self.id}.lib.js"
  end

  def to_json
    out = {}
    [:match_negative, :match_positive, :match_isbn, :name, :isbn_link, :update_url, :lat, :lng, :full_address, :id].each { |k| out[k] = self.send(k) }
    out.to_json
  end

  def bookburro?
    (not isbn_link.blank?) and scraper?
  end
  
  def scraper?
    [match_isbn?,
     !match_positive.blank?,
     !match_negative.blank?
    ].any?
  end 

  def bookmarklet
    bm = read_attribute(:bookmarklet)
    return bm unless bm.blank?

    return nil if isbn_link.blank?

    link = "'" + isbn_link.gsub('#{ISBN}', "'+isbn+'") + "'"
    BOOKMARKLET_BASE.gsub('LIBRARY_ISBN_LINK', link)
  end

  before_save :geocode_address # FIXME - only do this if address is changing...

  private
  
    def geocode_address
      return if self.location.blank?
      geo = GeoKit::Geocoders::MultiGeocoder.geocode(location)
      return if !geo.success
      self.attributes=({
        :lat => geo.lat,
        :lng => geo.lng,
        :full_address => geo.full_address,
        :country_code => geo.country_code,
        :state => geo.state,
        :city => geo.city        
      })
  end  
end
