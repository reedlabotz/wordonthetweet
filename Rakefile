FILES = {'js/*.min.js' => 'js/',
				 'js/lib/*' => 'js/lib/',
				 'css/*.min.css' => 'css/',
				 'AFINN-111-emo.txt' => ''}

task :default => [:compile, :minify]

task :compile do
	puts 'Compiling coffeescript -> application.js'
  `coffee --join js/application.js --compile src/*.coffee`
end

task :minify do
	puts 'Compressing bootstrap.css -> bootstrap.min.css'
	`recess --compress css/bootstrap.css > css/bootstrap.min.css`

	puts 'Compressing master.css -> master.min.css'
	`recess --compress css/master.css > css/master.min.css`
	
	puts 'Compressing application.js -> application.min.js'
	`uglifyjs -nc js/application.js > js/application.min.js`
end

task :publish => [:compile, :minify] do
	puts 'Creating publish'
	`mkdir publish`
	puts 'Copying files'
	FILES.each do |s,d|
		`mkdir -p publish/#{d}` unless d == '' 
		`mv #{s} publish/#{d}`
	end
	puts 'Changing links in html'
	replace_min('index.html','publish/index.html')
	puts 'Commit to gh-pages'
	`ORIG_HEAD="$(git name-rev --name-only HEAD)" && git checkout gh-pages && rm -rf $(ls * | grep -v '^publish$') && mv publish/* . && git add -A && git commit -am "automatic update" && git checkout "$ORIG_HEAD"`
end

task :clean do
	puts 'Removing application.js'
	`rm js/application.js`
	puts 'Removing application.min.js'
	`rm js/application.min.js`
	puts 'Removing bootstrap.min.css'
	`rm css/bootstrap.min.css`
	puts 'Removing master.min.css'
	`rm css/master.min.css`
end

def replace_min(file_path, file_out_path)
	file = File.open(file_path)
	out_file = File.new(file_out_path, "w")
	in_head = false
	file.each do |line|
		if !in_head
			in_head = true if line.strip == '<head>'
		else
			if line.strip == '</head>'
				in_head = false
			else
				line = line.gsub(/\.css/,'.min.css') if !line.include?('.min.css')
				line = line.gsub(/\.js/,'.min.js') if !line.include?('.min.js')
			end
		end
		out_file.puts(line)
	end
	file.close
	out_file.close
end
