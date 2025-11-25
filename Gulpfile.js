var gulp 				= require('gulp')
var browserSync = require('browser-sync').create()
var reload			= browserSync.reload

var files = [
  '*.html',
  '**/*.md',
  'themes/*.css',
  '**/*.{svg,png,jpg,gif}',

  '!node_modules/**/*',
];

gulp.task('browser-sync', function() {
	browserSync.init(files, {
		// Read here http://www.browsersync.io/docs/options/
		server: {
			baseDir: "./",
      directory: true
		},
		notify: false,
		port: 8080,
    localOnly: true,
		injectChanges: true,
    open: "local",
    ghostMode: false
	})
});

gulp.task('default', gulp.series('browser-sync'), function () {
  gulp.watch([files], browserSync.reload);
});
