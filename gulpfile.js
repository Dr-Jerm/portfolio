var gulp = require('gulp');

var concat = require('gulp-concat');
var rename = require('gulp-rename');
var coffee = require('gulp-coffee');
var stylus = require('gulp-stylus');
var gutil = require('gulp-util');

gulp.task('scripts', function() {
  return gulp.src('client/coffee/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('client.js'))
    .pipe(gulp.dest('assets/js'));
});

gulp.task('stylus', function () {
  return gulp.src('client/stylus/*.styl')
    .pipe(stylus())
    .pipe(concat('style.css'))
    .pipe(gulp.dest('assets/css'));
});

gulp.task('watch', function() {
  gulp.watch('client/coffee/*.coffee', ['scripts']);
  gulp.watch('client/stylus/*.styl', ['stylus']);
});

gulp.task('default', ['scripts', 'stylus', 'watch']);