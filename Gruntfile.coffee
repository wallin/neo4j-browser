"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)
proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest;

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-stylus'

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist/browser"

  try
    yeomanConfig.app = require("./component.json").appPath or yeomanConfig.app
  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:dist"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test"]

      stylus:
        files: 'app/styles/*.styl',
        tasks: ["stylus"]

      livereload:
        files: ["<%= yeoman.app %>/{,*/}*.html", "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css", "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]
        tasks: ["livereload"]

      jade:
        files: ['app/index.jade', 'app/views/**/*.jade', 'app/content/**/*.jade']
        tasks: ['jade']

    connect:
      options:
        port: 9000

        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "0.0.0.0"

      livereload:
        options:
          middleware: (connect) ->
            [proxySnippet, lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, yeomanConfig.app)]

      test:
        options:
          port: 9000
          middleware: (connect) ->
            [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]
      proxies: [
          {
              context: '/db',
              host: 'localhost',
              port: 7474,
              https: false,
              changeOrigin: false
          }
      ]


    open:
      server:
        url: "http://localhost:<%= connect.options.port %>"

    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*",
            "!<%= yeoman.dist %>/.git*",
            "<%= yeoman.app %>/views/*.html",
            "<%= yeoman.app %>/content/**/*.html"
          ]
        ]

      server: ".tmp"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js"]

    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true

    coffee:
      options:
        force: true
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]

      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    stylus:
      compile:
        files:
          '<%= yeoman.app %>/styles/main.css': ['<%= yeoman.app %>/styles/*.styl']
      options:
        paths: ["<%= yeoman.app %>/vendor/foundation", "<%= yeoman.app %>/images"]

    jade:
      index:
        src: ["<%= yeoman.app %>/index.jade"]
        dest: '<%= yeoman.app %>'
        options:
          client: false
          pretty: true
      html:
        src: ["<%= yeoman.app %>/views/*.jade"]
        dest: "<%= yeoman.app %>/views"
        options:
          client: false
          pretty: true
      content:
        src: ["<%= yeoman.app %>/content/**/*.jade"]
        dest: "<%= yeoman.app %>/content"
        options:
          client: false
          pretty: true
          basePath: "<%= yeoman.app %>/content/"

    concat:
      dist:
        files: {}

    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/**/*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "**/*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>/styles/main.css": [".tmp/styles/{,*/}*.css", "<%= yeoman.app %>/styles/{,*/}*.css"]

    htmlmin:
      dist:
        options: {}

        #removeCommentsFromCDATA: true,
        #          // https://github.com/yeoman/grunt-usemin/issues/44
        #          //collapseWhitespace: true,
        #          collapseBooleanAttributes: true,
        #          removeAttributeQuotes: true,
        #          removeRedundantAttributes: true,
        #          useShortDoctype: true,
        #          removeEmptyAttributes: true,
        #          removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["*.html", "views/*.html", "content/**/*.html"]
          dest: "<%= yeoman.dist %>"
        ]

    # cdnify:
    #   dist:
    #     html: ["<%= yeoman.dist %>/*.html"]

    ngmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/scripts"
          src: "*.js"
          dest: "<%= yeoman.dist %>/scripts"
        ]

    uglify:
      dist:
        files:
          "<%= yeoman.dist %>/scripts/scripts.js": ["<%= yeoman.dist %>/scripts/scripts.js"]

    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}", "<%= yeoman.dist %>/styles/fonts/*"]

    copy:
      dist:
        files: [{
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: ["*.{ico,txt}", "images/{,*/}*.{gif,webp}", "styles/fonts/*"]
          },
          {
            expand: true
            flatten: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>/font"
            src: ["components/**/*.{otf,woff,ttf,svg}"]
        }]
    shell:
      dirListing:
        command: 'ls',
        options:
            stdout: true

  grunt.renameTask "regarde", "watch"
  grunt.registerTask "server", ["clean:server", "coffee:dist", "configureProxies", "stylus", "jade", "livereload-start", "connect:livereload", "watch"]
  grunt.registerTask "test", ["clean:server", "coffee", "connect:test", "karma"]
  grunt.registerTask "build", ["clean:dist", "test", "coffee", "jade", "stylus", "useminPrepare", "imagemin", "cssmin", "htmlmin", "concat", "copy", "uglify", "usemin"]
  grunt.registerTask "default", ["build"]

  grunt.registerTask 'release', 'Coordinate release with maven.', (subject) ->
    shell = require('shelljs');
    semver = require('semver');
    
    if arguments.length == 0
      grunt.log.writeln(this.name + " world!")
    else
      grunt.log.writeln(this.name + " " + subject + "!")
    shell.exec("mvn --batch-mode -Dtag=my-proj-1.2 release:prepare" +
                " -DreleaseVersion=1.2 " +
                " -DdevelopmentVersion=2.0-SNAPSHOT -DdryRun=true"
    )