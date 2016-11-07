_ = require 'underscore'
ssi = require 'browsersync-ssi'
gulp = require 'gulp'
pug = require 'gulp-pug'
sass = require 'gulp-sass'
util = require 'gulp-util'
debug = require 'gulp-debug'
watch = require 'gulp-watch'
order = require 'gulp-order'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
notify = require 'gulp-notify'
changed = require 'gulp-changed'
greplace = require 'gulp-replace'
imagemin = require 'gulp-imagemin'
transform = require 'vinyl-transform'
sourcemaps = require 'gulp-sourcemaps'
browserify = require 'browserify'
browserSync = require 'browser-sync'
spritesmith = require 'gulp.spritesmith'
mediaqueries = require 'gulp-combine-media-queries'
plumber = require 'gulp-plumber'
watchify = require 'watchify'
pngcrush = require 'imagemin-pngcrush'
pngquant = require 'imagemin-pngquant'

expand = (ext)-> rename (path) -> _.tap path, (p) -> p.extname = ".#{ext}"
logfile = (filename) -> console.log(filename)

environment = process.env.NODE_ENV or "development"

DEST = "./dist"
SRC = "./src"
SCOPE = ""
CHANGED = "./__modified"

# ファイルタイプごとに無視するファイルなどを設定
PATH_ = ""
paths =
  js: ["#{SRC}/**/*.coffee", "!#{SRC}/**/_**/*.coffee", "!#{SRC}/**/_*.coffee"]
  jsw: ["#{SRC}#{SCOPE}/**/*.coffee", "#{SRC}#{SCOPE}/views/_templates/**/*.pug"]
  jslib: ["#{SRC}#{SCOPE}/**/*.js", "!#{SRC}#{SCOPE}/**/_*.js"]
  json: ["#{SRC}/**/*.json", "#{SRC}/**/*.php", "#{SRC}/**/_*.js", "!#{SRC}/**/libs/_*.js"]
  css: ["#{SRC}/**/*.scss", "!#{SRC}/**/sprite*.scss", "!#{SRC}/**/_**/*.scss", "!#{SRC}/**/_*.scss"]
  cssw: ["#{SRC}#{SCOPE}/**/*.scss"]
  img: ["#{SRC}/**/*.{png, jpg, gif}", "!#{SRC}/**/sprite/**/*.png"]
  html: ["#{SRC}/**/*.pug", "!#{SRC}/**/_**/*.pug", "!#{SRC}/**/_*.pug"]
  # htmlw: ["#{SRC}#{SCOPE}/**/*.pug"]
  htmlp: ["#{SRC}/**/_**/**/*.pug", "#{SRC}/**/_*.pug", "#{SRC}/**/pokemon/*.pug"]
  reload: ["#{DEST}#{SCOPE}/**/*", "!#{DEST}#{SCOPE}/**/*.css"]
  sprite: "#{SRC}/**/sprite/**/*.png"

gulp.task 'browserify', ->

  bundler = (options) ->
    transform (filename) ->
      b = browserify _.extend options, {}#watchify.args

      # watch
      #b = watchify b
      b.add filename

      # transform
      b.transform 'coffeeify'
      b.transform 'pugify'
      b.transform 'stylify'
      b.transform 'debowerify'

      # events
      b.on 'bundle', logfile.bind null, 'BUNDLE ' + filename
      b.on 'error', -> console.log "error"
      b.on 'log', -> console.log arguments
      b.on 'update', ->
        console.log "asdasd"
        bundle()

      b.bundle()

  bundle = ->
    gulp.src paths.js
      .pipe debug()
      .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')})
      .pipe bundler extensions: ['.coffee']
      .pipe expand "js"
      .pipe gulp.dest "#{DEST}"

  bundle()

gulp.task "json", ->

  gulp.src paths.json
    .pipe greplace(/\/\/[0-9]+,[0-9]+/g, "")
    .pipe gulp.dest DEST

gulp.task "sass", ->

  gulp.src paths.css
    .pipe plumber()
    .pipe sourcemaps.init()
    .pipe(sass.sync().on('error', (err) -> console.error('Error!', err.message)))
    .pipe sourcemaps.write()
    .pipe gulp.dest DEST
    .pipe browserSync.reload stream:true

gulp.task "sass-prod", ->

  gulp.src paths.css
    .pipe plumber()
    .pipe(sass.sync().on('error', (err) -> console.error('Error!', err.message)))
    #.pipe mediaqueries()
    .pipe expand "css"
    .pipe gulp.dest DEST

gulp.task "pug", ->
  gulp.src paths.html
    .pipe plumber()
    .pipe pug pretty: false
    .pipe expand "html"
    .pipe gulp.dest DEST

gulp.task "imagemin", ->
  gulp.src paths.img
    .pipe imagemin
      use: [pngcrush(), pngquant()]
    .pipe gulp.dest DEST

gulp.task "js", ->
  gulp.src paths.jslib
    .pipe order([
      "**/jquery*.min.js",
      "**/underscore-min.js",
      "**/*.js"
    ])
    .pipe concat('libs.js')
    .pipe uglify()
    .pipe gulp.dest "#{DEST}#{SCOPE}/common/js/libs/"

gulp.task "browser-sync", ->
  browserSync
    ghostMode: false
    port: 5100
    reloadDebounce: 400
    scrollProportionally: true
    server: 
      baseDir: DEST
      middleware: ssi
        baseDir: DEST
        ext: '.html'
        

# http://blog.e-riverstyle.com/2014/02/gulpspritesmithcss-spritegulp.html
gulp.task "sprite", ->
  a = gulp.src paths.sprite
    .pipe plumber()
    .pipe spritesmith
      imgName: 'common/images/sprite.png'
      cssName: 'common/css/_helpers/sprite.scss'
      imgPath: '../images/sprite.png'
      algorithm: 'binary-tree'
      cssFormat: 'scss'
      padding: 2

  a.img.pipe gulp.dest SRC
  a.img.pipe gulp.dest DEST
  a.css.pipe gulp.dest SRC


PATH_ = paths.html
DISTPATH_ = DEST

gulp.task 'pug2', ->
 gulp.src PATH_
   .pipe debug()
   .pipe plumber()
   .pipe pug
     pretty: false,
     basedir: '_src/'
   .pipe expand 'html'
   # .pipe prettify { indent_size: 0}
   .pipe gulp.dest DISTPATH_

pugWatch = (epath) ->
 PATH_ = epath
 # dist path
 c = PATH_.split('¥').join('/')
 c = c.split('\\').join('/')
 filepaths = c.split('/')
 distpath = DEST
 atRoot = 0

 for i in [0..filepaths.length - 2]
   if filepaths[i] is 'src'
     distpath = distpath + '/'
     atRoot = true
   else if atRoot
     distpath = distpath + filepaths[i] + '/'
 DISTPATH_ = distpath


gulp.task 'watch2', (e) ->

  watch paths.html , (e) ->
    console.log '----------------------------------------'
    re = /( - )/
    PATH_ = e.path
    if PATH_.match(re)
      console.log 'this is copipe file ...'
      return false
    else
      pugWatch(e.path)
      gulp.start ['pug2']

  watch paths.htmlp, (e) ->
    console.log '----------------------------------------'

    gulp.start ['pug']





gulp.task 'watch', ->
  gulp.watch paths.jsw, ['browserify']
  gulp.watch paths.cssw  , ['sass']
  # gulp.watch paths.htmlw , ['pug']
  gulp.watch paths.jslib, ['js']
  gulp.watch paths.json, ['json']
  gulp.watch paths.reload, -> browserSync.reload once: true

gulp.task "default", ['pug', 'sass', 'js', 'json', 'browserify', 'browser-sync', 'watch', 'watch2']
gulp.task "build", ['imagemin', 'sass-prod', 'js', 'json', 'browserify', 'pug']
