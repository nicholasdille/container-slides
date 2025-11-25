var gulp = require('gulp');

var browserSync = require('browser-sync').create();

gulp.task('browserSync', function() {
   browserSync.init({
      server: {
         baseDir: '.'
      },
   })
})

gulp.task('reload', function() {   
   gulp.pipe(browserSync.reload({
      stream: true
   }))
});

gulp.task('default', gulp.series('browserSync', function() {
   gulp.watch('160_gitlab_ci/**', function() {
      gulp.run('reload')
   });
}));