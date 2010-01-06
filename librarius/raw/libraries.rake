namespace :library do
  namespace :lookup do
    desc 'import all the library lookup libraries'
    task :import => [:environment, :voyager, :innovative, :dra, :talis, :isbn_link]

    task :voyager do
      link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
      three = /(USA|Australia|Canada) - ([^-]*) - ([^-]*) - (.*)/
      two = %r|([^-]*) - ([^-]*) - (.*)|
      open("#{RAILS_ROOT}/raw/Voyager.html").each_line do |line|
        if link.match(line)
          bookmarklet = $1
          label = $2
          if three.match(label)
            name = $4
            location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'voyager', :source => 'Library Lookup'
          elsif two.match(label)
            name = $3
            location = [$2, $1].compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'voyager', :source => 'Library Lookup'
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
      open("#{RAILS_ROOT}/raw/Innovative.html").each_line do |line|
        if link.match(line)
          bookmarklet = $1
          label = $2
          if three.match(label)
            name = $4
            location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'innovative', :source => 'Library Lookup'
          elsif two.match(label)
            name = $3
            location = [$2, $1].compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'innovative', :source => 'Library Lookup'
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
      open("#{RAILS_ROOT}/raw/DRA.html").each_line do |line|
        if link.match(line)
          bookmarklet = $1
          label = $2
          if three.match(label)
            name = $4
            location = [$3, $2, $1].collect { |s| s unless s.blank? }.compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'dra', :source => 'Library Lookup'
          elsif two.match(label)
            name = $3
            location = [$2, $1].compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'dra', :source => 'Library Lookup'
          else
            puts "oops! fix #{line}"
          end
        end
      end
    end

    task :talis do
      link = %r|^\s*<a href="(javascript:[^"]*)">([^<]*)<\/a><br>|
      two = %r|([^-]*) - ([^-]*) - (.*)|
      open("#{RAILS_ROOT}/raw/Talis.html").each_line do |line|
        if link.match(line)
          bookmarklet = $1
          label = $2
          if two.match(label)
            name = $3
            location = [$2, $1].compact.join(', ')
            Library.create :location => location, :name => name, :bookmarklet => bookmarklet, :opac => 'talis', :source => 'Library Lookup'
          else
            puts "oops! fix #{line}"
          end
        end
      end
    end

    task :isbn_link do
      isbn = '#{ISBN}'

      re = /window.open\((.*),'LibraryLookup','scrollbars=1,resizable=1,width=575,height=500'/
      Library.find(:all, :conditions => ['source = ?', 'Library Lookup']).each do |lib|
        if re.match(lib.bookmarklet)
          lib.update_attribute(:isbn_link, eval($1))
        else
          puts "ERROR - fix for: #{lib.name}"
        end
      end
    end
  end

  namespace :bookburro do
    desc 'import the libraries from book burro'
    task :import => :environment do
      JSON.parse(open("#{RAILS_ROOT}/raw/bookburro.json").read).each do |bblib|

        library = Library.create :name => bblib['title'], :isbn_link => bblib['link'],
          :source => 'Book Burro', :match_negative => bblib['missing_term'],
          :match_positive => bblib['found_term'], :match_isbn => bblib['match_isbn']

        case bblib['dont']
        when String
          library.checks.create :expects => false, :isbn => bblib['dont']
        when Array
          bblib['dont'].each do |isbn|
            library.checks.create :expects => false, :isbn => isbn
          end
        end

        case bblib['have']
        when String
          library.checks.create :expects => true, :isbn => bblib['have']
        when Array
          bblib['have'].each do |isbn|
            library.checks.create :expects => true, :isbn => isbn
          end
        end

      end
    end
  end
end