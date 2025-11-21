var gulp = require('gulp');
var connect = require('connect');
var connectLivereload = require('connect-livereload');
var opn = require('opn');
var gulpLivereload = require('gulp-livereload');

var config = {
    rootDir: __dirname,
    servingPort: 8080,

    // the files you want to watch for changes for live reload
    filesToWatch: ['*.{html,css,js}', '!Gulpfile.js']
}

// The default task - called when you run `gulp` from CLI
gulp.task('default', ['watch', 'serve']);

gulp.task('watch', ['connect'], function () {
  gulpLivereload.listen();
  gulp.watch(config.filesToWatch, function(file) {
    gulp.src(file.path)
      .pipe(gulpLivereload());
  });
});

gulp.task('serve', ['connect'], function () {
  return opn('http://localhost:' + config.servingPort);
});

gulp.task('connect', function(){
  return connect()
    .use(connectLivereload())
    .use(connect.static(config.rootDir))
    .listen(config.servingPort);
});
