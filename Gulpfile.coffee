gulp = require 'gulp'
mocha = require 'gulp-mocha'

gulp.task 'test', ->
  gulp.src './tests/**/*.coffee'
  .pipe mocha()
  .once 'end', -> process.exit()
