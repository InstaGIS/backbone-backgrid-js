module.exports = function (config) {
  config.set({
    basePath: '',
    port: 9877,
    colors: true,
    logLevel: 'INFO',
    autoWatch: false,
    browsers: ['PhantomJS'],
    singleRun: true,
    frameworks: ['qunit'],
    reporters: ['progress'],
    files: [
      'test/vendor/object-assign-polyfill.js',
      'test/vendor/prototype-bind-polyfill.js',
      'test/vendor/bluebird.js',
      'test/vendor/jquery.min.js',
      'test/vendor/underscore.js',
      'dist/ig_backbone.bundle.js',
      'test/ig_backbone/setup/*.js',
      'test/ig_backbone/*.js'
    ]
  });
};
