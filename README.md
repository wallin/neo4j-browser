neo4j-ui
========

Client app built-in to Neo4j.

# Getting started

This project was generated using [Yeoman](http://yeoman.io) and the [AngularJS generator](https://github.com/yeoman/generator-angular)

## Pre-requisites

* [git](https://help.github.com/articles/set-up-git) (of course :smiley: ) - to get source
* [NodeJS + NPM](http://nodejs.org/) - for building and hosting the application
* [PhantomJS](http://phantomjs.org) - for testing
* [SBT](http://www.scala-sbt.org) - for packaging up as a maven artifact
  - the `tools` directory has an sbt script and the needed jar

## Install

    $ npm install -g yo grunt-cli bower
    $ npm install -g generator-angular

    $ npm install
    $ bower install

## Run Neo4j

The tools directory has a small SBT project which builds and runs a local Neo4j server
as a "test" application.

    $ ./tools/sbt test:run

## Develop

    $ grunt server   # Run server for development
    $ grunt          # Build the application for production
    $ grunt clean    # Clean build files

### Running tests

    $ grunt test     # Single test run
    $ karma start    # Continously run tests as source files changes

### Adding new files

The [AngularJS generator](https://github.com/yeoman/generator-angular) provides a couple of Yeoman tasks for generating new files. Eg. to generate a new controller:

    $ yo angular:controller user --coffee --minsafe

Type `yo` or see [AngularJS generator](https://github.com/yeoman/generator-angular) for complete reference

### Adding new dependencies

[Bower](http://bower.io) is used to install and add new package, eg:

    $ bower install jquery --save

This will automatically add the dependency to the `bower.json` file.

## Production
    $ grunt build

Test with local webserver at port 5000 (requires ruby)

    $ cd dist
    $ ruby -run -e httpd . -p5000
    $ open http://localhost:5000

## Publish

    $ grunt build            # Build the application for distribution
    $ ./tools/sbt publish    # Build a maven artifact which Neo4j can integrate


## Documentation and resources

* [Getting started with Yeoman](http://yeoman.io/gettingstarted.html)
* [Angular tutorials](http://www.egghead.io/)
* [Angular best practices](http://www.youtube.com/watch?v=ZhfUv0spHCY)
* [Karma test runner introduction](http://www.youtube.com/watch?v=MVw8N3hTfCI)
