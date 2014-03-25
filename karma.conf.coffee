module.exports = (config) ->
  config.set
    
    basePath: "."
    
    frameworks: ["jasmine"]

    preprocessors:
      "test/**/*.coffee": ["coffee"]

    files: [
      "assets/**/*.coffee"
      "test/**/*.coffee"
      "test/vendor/angular-mocks.js"
    ]
    
    exclude: []
    
    reporters: ["progress","coverage"]

    coverageReporter:
      type: 'html'
      dir: 'coverage'
    
    port: 9876
    
    colors: true
    
    logLevel: config.LOG_INFO
    
    autoWatch: true
    
    browsers: ["PhantomJS"]
    
    captureTimeout: 60000
    
    singleRun: true