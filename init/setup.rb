require 'rubygems'
require 'restclient'
require 'json'

DB = 'http://127.0.0.1:5984/libraries'

RestClient.delete DB

RestClient.put(DB, '')

RestClient.put "#{DB}/_design/bookburro", <<EOS
{
  "views":{
    "flat":{
      "map":"function (doc) { emit(doc._id, doc.title); }"
    }
  }
}
EOS

JSON.parse(open('libraries.json').read).each do |lib|
  begin
    url = "#{DB}/#{lib['name']}"
    lib.delete('name')
    RestClient.put url, lib.to_json, :content_type => 'application/json'
  rescue Object => e
    p e
  end
end
