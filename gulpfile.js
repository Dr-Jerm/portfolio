var gulp = require('gulp');

var concat = require('gulp-concat');
var rename = require('gulp-rename');
var coffee = require('gulp-coffee');
var stylus = require('gulp-stylus');
var gutil = require('gulp-util');

gulp.task('scripts', function() {
  return gulp.src('app/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('app.min.js'))
    .pipe(gulp.dest('release/js'));
});

var vendorJsArray = ['app/vendor/vendorJs/angular.min.js','app/vendor/vendorJs/angular-animate.min.js','app/vendor/vendorJs/*.js']
gulp.task('vendorJs', function() {
  return gulp.src(vendorJsArray)
    .pipe(concat('vendor.min.js'))
    .pipe(gulp.dest('release/js'))
})

gulp.task('stylus', function () {
  return gulp.src('app/app.styl')
    .pipe(stylus({errors: true}).on('error', function(){}))
    .pipe(concat('style.css'))
    .pipe(gulp.dest('release/css'));
});

gulp.task('vendorCss', function() {
  return gulp.src('app/vendor/vendorCss/*.css')
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('release/css'))
})

gulp.task('watch', function() {
  gulp.watch('app/**/*.coffee', ['scripts']);
  gulp.watch('app/**/*.styl', ['stylus']);
  gulp.watch('app/vendor/vendorCss/*.css', ['vendorCss'])
  gulp.watch('app/vendor/vendorJs/*.js', ['vendorJs'])
});

gulp.task('default', ['scripts', 'vendorJs',  'stylus', 'vendorCss', 'watch']);
