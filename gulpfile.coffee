# Load all required libraries.
gulp       = require 'gulp'
$          = require('gulp-load-plugins')()
stylus     = require 'gulp-stylus'
prefix     = require 'gulp-autoprefixer'
cssmin     = require 'gulp-cssmin'
jade       = require 'gulp-jade'
minifyHTML = require 'gulp-minify-html'
postcss    = require 'gulp-postcss'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
csso       = require 'gulp-csso'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
coffeelint = require 'gulp-coffeelint'
connect		 = require 'gulp-connect'

buildFolder = 'build'

gulp.task 'connect', ->
  connect.server
    port: 1337
    livereload: on
    root: buildFolder

gulp.task 'stylus', ->
  gulp.src ['src/styles/**/*.styl','!src/styles/**/_*.styl']
  .pipe stylus()
  .pipe concat 'style.css'
  .pipe prefix '> 1%'
  .pipe csso()
  .pipe gulp.dest buildFolder+'/css'

gulp.task 'css', ->
  gulp.src ['src/styles/**/*.css','!src/styles/**/_*.css']
  .pipe concat 'libs.css'
  .pipe prefix '> 1%'
  .pipe csso()
  .pipe gulp.dest buildFolder+'/css'

gulp.task 'html', ->
  gulp.src ['src/layouts/**/*.jade','!src/layouts/**/_*.jade']
  .pipe jade()
  .pipe minifyHTML()
  .pipe gulp.dest buildFolder+''

gulp.task 'coffee', ->
  browserify
    entries: ['./src/scripts/main.coffee']
    extensions: ['.coffee']
  .bundle()
  .pipe source 'main.js'
  .pipe gulp.dest buildFolder+'/js'

gulp.task 'lint', ->
  gulp.src 'src/**/*.coffee'
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())

gulp.task 'js', ->
  gulp.src './src/scripts/libs/*.js'
  .pipe concat 'libs.js'
  .pipe gulp.dest buildFolder+'/js'

gulp.task 'copy', ->
  gulp.src ['./src/files/**/*.*']
  .pipe gulp.dest buildFolder

gulp.task 'default', ['stylus','css','html','coffee','js','lint', 'copy','connect'], ->
  gulp.watch 'src/styles/**/*.styl',['stylus','css']
  gulp.watch 'src/layouts/**/*.jade',['html']
  gulp.watch ['src/scripts/**/*.coffee','src/layouts/templates/*.hbs'],['coffee']
  gulp.watch './src/scripts/libs/*.js',['js']
