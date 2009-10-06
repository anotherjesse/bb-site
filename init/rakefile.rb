require 'rubygems'
require 'restclient'
require 'activesupport'
require 'json'

DB = 'http://127.0.0.1:5984/libraries'

def isbn_linkize(lib)
  # library lookup bookmarklets look like: 'foo' + isbn + 'bar'
  # so we find the string that is evaled by the bookmarklet and
  # eval it ourselves.

  isbn = '#{ISBN}'

  re = /window.open\((.*),'LibraryLookup','scrollbars=1,resizable=1,width=575,height=500'/
  if lib[:bookmarklet]
    if re.match(lib[:bookmarklet])
      lib[:link] = eval($1)
    else
      puts "No match for ", lib[:name]
    end
  end
end

def add_library(lib)
  isbn_linkize(lib)
  RestClient.post DB, lib.to_json, :content_type => 'application/json'
end

desc '(re)create the libraries database in couchdb'
task :init_db do
  RestClient.delete DB rescue nil
  RestClient.put(DB, '')
  RestClient.put "#{DB}/_design/bookburro", '{ "views":{ "flat":{ "map":"function (doc) { emit(doc._id, doc.title); }" } } }'
end

task :init => [:init_db, :bookburro, :library_lookup]

desc 'import all the library lookup libraries'
task :library_lookup => [:voyager, :innovative, :dra, :talis]

desc 'import voyager libraries from library lookup project'
task :voyager do
  link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
  three = /(USA|Australia|Canada) - ([^-]*) - ([^-]*) - (.*)/
  two = %r|([^-]*) - ([^-]*) - (.*)|
  open("Voyager.html").each_line do |line|
    if link.match(line)
      bookmarklet = $1
      label = $2
      if three.match(label)
        name = $4
        location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'voyager', :source => 'Library Lookup'
      elsif two.match(label)
        name = $3
        location = [$2, $1].compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'voyager', :source => 'Library Lookup'
      else
        puts "oops! fix #{line}"
      end
    end
  end
end

task :innovative do
  link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
  three = /(USA|Australia|Canada) - ([^-]*) - ([^-]*) - (.*)/
  two = %r|([^-]*) - ([^-]*) - (.*)|
  open("Innovative.html").each_line do |line|
    if link.match(line)
      bookmarklet = $1
      label = $2
      if three.match(label)
        name = $4
        location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'innovative', :source => 'Library Lookup'
      elsif two.match(label)
        name = $3
        location = [$2, $1].compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'innovative', :source => 'Library Lookup'
      else
        puts "oops! fix #{line}"
      end
    end
  end
end

task :dra do
  link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
  three = /(USA|Australia|Canada) - ([^-]*) - ([^-]*) - (.*)/
  two = %r|([^-]*) - ([^-]*) - (.*)|
  open("DRA.html").each_line do |line|
    if link.match(line)
      bookmarklet = $1
      label = $2
      if three.match(label)
        name = $4
        location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'dra', :source => 'Library Lookup'
      elsif two.match(label)
        name = $3
        location = [$2, $1].compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'dra', :source => 'Library Lookup'
      else
        puts "oops! fix #{line}"
      end
    end
  end
end

task :talis do
  link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
  two = %r|([^-]*) - ([^-]*) - (.*)|
  open("Talis.html").each_line do |line|
    if link.match(line)
      bookmarklet = $1
      label = $2
      if two.match(label)
        name = $3
        location = [$2, $1].compact.join(', ')
        add_library :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'talis', :source => 'Library Lookup'
      else
        puts "oops! fix #{line}"
      end
    end
  end
end

desc 'import the libraries from book burro 0.70'
task :bookburro do
  JSON.parse(open('bookburro.json').read).each do |lib|
    begin
      url = "#{DB}/#{lib['name']}"
      lib.delete('name')
      lib['source'] = 'Book Burro'
      RestClient.put url, lib.to_json, :content_type => 'application/json'
    rescue Object => e
      p url, e
    end
  end
end
