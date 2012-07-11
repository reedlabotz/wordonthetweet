toast
  # SRC FOLDERS
  folders:
      "src/app": "app"
      "scripts": "scripts"

  # EXCLUDED FOLDERS
  exclude: ['src/main.coffee']

  # => VENDORS and EXCLUDED FOLDERS (optional)
  # vendors: ['vendors/x.js', 'vendors/y.js', ... ]

  # => OPTIONS (optional, default values listed)
  # bare: false
  # packaging: true
  # expose: ''
  minify: false

  # => HTTPFOLDER (optional), RELEASE / DEBUG (required)
  httpfolder: 'scripts/js'
  release: 'scripts/js/app.js'
  debug: 'scripts/js/app-debug.js'