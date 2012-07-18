task :default => [:clean, :compile]

task :compile do
  puts 'Compiling coffeescript -> app.js'
  run_command("toaster -c")
end

task :publish => [:clean, :compile] do
  puts 'Commit to gh-pages'
  run_command("ORIG_HEAD=\"$(git name-rev --name-only HEAD)\" && git checkout gh-pages && rm -rf $(ls * | grep -v '^www$') && mv www/* . && git add -A && git commit -am \"automatic update\" && git checkout \"$ORIG_HEAD\"")
  puts 'Removing publish'
  run_command("rm -rf publish")
end

task :clean do
  puts 'Removing app.js'
  run_command("rm www/js/app.js")
  puts 'Removing app-debug.js'
  run_command("rm www/js/app-debug.js")
  run_command("rm -rf www/js/toaster")
end

task :watch do
  run_command("toaster -wd")
end

task :server do
  run_command("cd www && python -m SimpleHTTPServer")
end

def run_command(command)
  IO.popen command do |fd|
    until fd.eof?
      puts fd.readline
    end
  end
end
