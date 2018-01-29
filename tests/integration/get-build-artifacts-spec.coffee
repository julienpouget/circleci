CircleCI = require "../../src/circleci"

describe "getBuildArtifacts", ->

  before ->
    @circleci = new CircleCI { auth: process.env.CIRCLE_TOKEN }
    @config =
      username: process.env.CIRCLE_USER
      project: process.env.CIRCLE_PROJECT
      vcsType: process.env.CIRCLE_VCSTYPE
      build_num: "7"

  it "returns the build artifacts", (done) ->
    @circleci.getBuildArtifacts(@config).then (res) ->
      expect(res).to.be.ok
      done()
