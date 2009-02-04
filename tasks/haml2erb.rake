require 'config/environment'
require 'haml2erb'

task :haml2erb do
  Dir[RAILS_ROOT + '/app/views/**/*.haml'].each do |filename|
    File.open(filename.sub(/\.haml$/, '') + ".erb", 'w') do |w|
      w << Haml2Erb.convert(filename)
    end
  end
end
