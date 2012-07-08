FILES = {'js/*.min.js' => 'js/',
         'js/lib/*' => 'js/lib/',
         'css/*.min.css' => 'css/',
         'img/*' => 'img/',
         'font/*' => 'font/',
         'AFINN-111-emo.txt' => ''}

task :default => [:compile, :minify, :prepare]

task :compile do
  puts 'Compiling coffeescript -> application.js'
  run_command("coffee --join js/application.js --compile src/")
end

task :minify do
  puts 'Compressing master.css -> master.min.css'
  run_command("recess --compress css/master.css > css/master.min.css")
  
  puts 'Compressing application.js -> application.min.js'
  run_command("uglifyjs -nc js/application.js > js/application.min.js")
end

task :publish => [:compile, :minify, :prepare] do
  puts 'Creating publish'
  run_command("mkdir publish")
  puts 'Copying files'
  FILES.each do |s,d|
    run_command("mkdir -p publish/#{d}") unless d == '' 
    run_command("mv #{s} publish/#{d}")
  end
  puts 'Changing links in html'
  replace_min('index.html','publish/index.html')
  puts 'Commit to gh-pages'
  run_command("ORIG_HEAD=\"$(git name-rev --name-only HEAD)\" && git checkout gh-pages && rm -rf $(ls * | grep -v '^publish$') && mv publish/* . && git add -A && git commit -am \"automatic update\" && git checkout \"$ORIG_HEAD\"")
  puts 'Removing publish'
  run_command("rm -rf publish")
end

task :prepare do
  puts 'Creating data'
  run_command('mkdir data')
  puts 'Copying naiveBayesClassifier.coffee in'
  run_command('cp src/classifiers/naiveBayesClassifier.coffee scripts/')
  puts 'Copying tweet.coffee in'
  run_command('cp src/tweet.coffee scripts/')
  puts 'Running script'
  run_command('coffee --join scripts/out.js --compile scripts/')
  run_command('node --max-old-space-size=1900 scripts/out.js')
  run_command('rm scripts/out.js')
  puts 'Removing naiveBayesClassifier.coffee'
  run_command('rm scripts/naiveBayesClassifier.coffee')
  puts 'Removing tweet.coffee'
  run_command('rm scripts/tweet.coffee')
  puts 'Copying afinn-111-emo.json -> data'
  run_command('cp raw_data/afinn-111-emo.json data/')
end

task :clean do
  puts 'Removing application.js'
  run_command("rm js/application.js")
  puts 'Removing application.min.js'
  run_command("rm js/application.min.js")
  puts 'Removing master.min.css'
  run_command("rm css/master.min.css")
  puts 'Removing data'
  run_command("rm -rf data/")
end

task :watch do
  run_command("coffee --watch --join js/application.js --compile src/")
end

task :server do
  run_command("python -m SimpleHTTPServer")
end

def replace_min(file_path, file_out_path)
  file = File.open(file_path)
  out_file = File.new(file_out_path, "w")
  file.each do |line|
    line = line.gsub(/\.css/,'.min.css') if !line.include?('.min.css') && line.include?('<link')
    line = line.gsub(/\.js/,'.min.js') if !line.include?('.min.js') && line.include?('<script')
    out_file.puts(line)
  end
  file.close
  out_file.close
end

def run_command(command)
  IO.popen command do |fd|
    until fd.eof?
      puts fd.readline
    end
  end
end
