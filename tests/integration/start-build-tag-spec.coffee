require 'coffee-script/register'
expect = require('chai').expect
sinon = require('sinon')
CircleCI = require "../../src/circleci"
APIHelper = require "../helpers/api-helper"

describe "startBuild", ->

  before ->
    @circleci = new CircleCI { auth: process.env.CIRCLE_TOKEN }
    @config =
      username: process.env.CIRCLE_USER
      project: process.env.CIRCLE_PROJECT
      body:
        tag: 'v0.1.0'
        parallel: null
        revision: null
        build_parameters:
          NODE_ENV: "production"
          FOO: "bar"

  it "starts the build", (done) ->
    @circleci.startBuildTag(@config).then (res) ->
      expect(res).to.be.ok
      APIHelper.cancelBuild res.build_num, -> done()
    .catch (err) ->
      done(err)
