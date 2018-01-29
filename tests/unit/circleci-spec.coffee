CircleCI = require "../../src/circleci"

describe "CircleCI Client", ->

  describe "initializing without an api token", ->

    it "throws an error", ->
      expect(-> new CircleCI()).to.throw

  describe "calling", ->

    before ->
      @circleci = new CircleCI { auth: "example-token" }

    beforeEach ->
      @processSpy = sinon.spy(@circleci.request, "process")

    afterEach ->
      @circleci.request.process.restore()

    describe "getUser", ->

      before ->
        @route = { path: "/me", method: "GET" }

      it "gets the current user", ->
        @circleci.getUser()
        expect(@processSpy.args[0][0]).to.deep.equal @route
        expect(@processSpy.args[0][1]).to.not.exist

    describe "getProjects", ->

      before ->
        @route = { path: "/projects", method: "GET" }

      it "gets the projects", ->
        @circleci.getProjects()
        expect(@processSpy.args[0][0]).to.deep.equal @route
        expect(@processSpy.args[0][1]).to.not.exist

    describe "getRecentBuilds", ->

      before ->
        @route = { path: "/recent-builds", method: "GET", options: ["limit", "offset"] }
        @options = { limit: 10, offset: 100 }

      describe "without options", ->

        it "gets the recent build", ->
          @circleci.getRecentBuilds()
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.not.exist

      describe "with options", ->

        it "gets the recent builds", ->
          @circleci.getRecentBuilds(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

    describe "getBuilds", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project", method: "GET", options: ["limit", "offset", "filter"] }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', limit: 10, offset: 100, filter: 'running' }

      it "gets the builds for a project", ->
          @circleci.getBuilds(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when 'username' and 'project' are missing", ->
        expect(-> @circleci.getBuilds()).to.throw

    describe "getBranchBuilds", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/tree/:branch", method: "GET", options: ["limit", "offset", "filter"] }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', branch: "master", limit: 10, offset: 100 }

      it "gets the builds for a project", ->
          @circleci.getBranchBuilds(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when 'username' and 'project' are missing", ->
        expect(-> @circleci.getBranchBuilds()).to.throw

      it "throws an error when 'branch' is missing", ->
        expect(-> @circleci.getBranchBuilds({ username: "jpstevens", project: "circleci"})).to.throw

    describe "getBuild", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/:build_num", method: "GET" }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', build_num: 123 }

      it "getting a single build for a project", ->
          @circleci.getBuild(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when options are missing", ->
        expect(-> @circleci.getBuild()).to.throw

    describe "getBuildArtifacts", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/:build_num/artifacts", method: "GET" }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', build_num: 123 }

      it "gets the artifacts for a build", ->
          @circleci.getBuildArtifacts(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when options are missing", ->
        expect(-> @circleci.getBuildArtifacts()).to.throw

    describe "retryBuild", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/:build_num/retry", method: "POST" }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', build_num: 123 }

      it "retries the build", ->
          @circleci.retryBuild(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when 'username', 'project' or 'build_num' are missing", ->
        expect(-> @circleci.retryBuild()).to.throw

    describe "cancelBuild", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/:build_num/cancel", method: "POST" }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', build_num: 123 }

      it "cancels a build", ->
          @circleci.cancelBuild(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when options are missing", ->
        expect(-> @circleci.cancelBuild()).to.throw

    describe "startBuild", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/tree/:branch", method: "POST" }
        @options = { username: "jpstevens", project: "circleci", vcsType:'github', branch: "master" }

      it "starts a build", ->
          @circleci.startBuild(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when options are missing", ->
        expect(-> @circleci.startBuild()).to.throw

    describe "clearBuildCache", ->

      before ->
        @route = { path: "/project/:vcsType/:username/:project/build-cache", method: "DELETE" }
        @options = { username: "jpstevens", project: "circleci",  vcsType:'github' }

      it "clears the cache for a project", ->
          @circleci.clearBuildCache(@options)
          expect(@processSpy.args[0][0]).to.deep.equal @route
          expect(@processSpy.args[0][1]).to.deep.equal @options

      it "throws an error when options are missing", ->
        expect(-> @circleci.clearBuildCache()).to.throw

    describe "getTestMetadata", ->

     before ->
       @route = { path: "/project/:vcsType/:username/:project/:build_num/tests", method: "GET" }
       @options = { username: "jpstevens", project: "circleci", vcsType:'github', build_num: 123 }

     it "gets the artifacts for a build", ->
         @circleci.getTestMetadata(@options)
         expect(@processSpy.args[0][0]).to.deep.equal @route
         expect(@processSpy.args[0][1]).to.deep.equal @options

     it "throws an error when options are missing", ->
       expect(-> @circleci.getTestMetadata()).to.throw

    describe "getEnvVars", ->

     before ->
       @route = { path: "/project/:vcsType/:username/:project/envvar", method: "GET" }
       @options = { username: "jpstevens", project: "circleci", vcsType:'github' }

     it "gets the env vars for a project", ->
       @circleci.getEnvVars(@options)
       expect(@processSpy.args[0][0]).to.deep.equal @route
       expect(@processSpy.args[0][1]).to.deep.equal @options

     it "throws an error when options are missing", ->
       expect(-> @circleci.getEnvVars()).to.throw

    describe "getEnvVar", ->

     before ->
       @route = { path: "/project/:vcsType/:username/:project/envvar/:name", method: "GET" }
       @options = { username: "jpstevens", project: "circleci", vcsType:'github', name: "NPM_TOKEN" }

     it "gets and env var by name for a project", ->
       @circleci.getEnvVar(@options)
       expect(@processSpy.args[0][0]).to.deep.equal @route
       expect(@processSpy.args[0][1]).to.deep.equal @options

     it "throws an error when options are missing", ->
       expect(-> @circleci.getEnvVar()).to.throw

    describe "setEnvVar", ->

     before ->
       @route = { path: "/project/:vcsType/:username/:project/envvar", method: "POST" }
       @options = { username: "jpstevens", project: "circleci", vcsType:'github', body: { name: "NPM_TOKEN", value: "123-456-789" } }

     it "sets env var for a project", ->
       @circleci.setEnvVar(@options)
       expect(@processSpy.args[0][0]).to.deep.equal @route
       expect(@processSpy.args[0][1]).to.deep.equal @options

     it "throws an error when options are missing", ->
       expect(-> @circleci.setEnvVar()).to.throw

    describe "deleteEnvVar", ->

     before ->
       @route = { path: "/project/:vcsType/:username/:project/envvar/:name", method: "DELETE" }
       @options = { username: "jpstevens", project: "circleci", vcsType:'github', name: "NPM_TOKEN" }

     it "sets env var for a project", ->
       @circleci.deleteEnvVar(@options)
       expect(@processSpy.args[0][0]).to.deep.equal @route
       expect(@processSpy.args[0][1]).to.deep.equal @options

     it "throws an error when options are missing", ->
       expect(-> @circleci.deleteEnvVar()).to.throw
