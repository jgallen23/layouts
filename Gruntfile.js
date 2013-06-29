module.exports = function(grunt) {
  grunt.initConfig({
    info: grunt.file.readJSON('package.json'),
    dist: 'dist/layouts.applescript',
    compiledDist: 'dist/layouts.scpt',
    meta: {
      banner: '-- <%= info.name %>\n'+
              '-- v<%= info.version %>\n'+
              '-- <%= info.homepage %>\n'+
              '-- copyright <%= info.copyright %> <%= grunt.template.today("yyyy") %>\n'+
              '-- <%= info.license %> License\n'+
              '\n'
    },
    concat: {
      app: {
        options: {
          banner: '<%= meta.banner %>'
        },
        src: [
          'lib/utils.applescript',
          'lib/displays.applescript',
          'lib/resize.applescript',
          'lib/layouts.applescript'
        ],
        dest: '<%= dist %>'
      }
    },
    shell: {
      compile: {
        command: 'osacompile -o <%= compiledDist %> <%= dist %>'
      },
      test: {
        command: 'osascript <%= compiledDist %> "test"',
        options: {
          stdout: true,
          stderr: true
        }
      },
      alfred: {
        command: 'cp -v <%= compiledDist %> alfred-workflow/ && cp -v dist/screens alfred-workflow/',
        options: {
          stdout: true
        }
      },
      alfredVersion: {
        command: 'sed -i "" "s/Simple Window Manager.*</Simple Window Manager v<%= info.version %></" alfred-workflow/info.plist'
      },
      alfredZip: {
        command: 'cd alfred-workflow/ && zip tmp * && mv tmp.zip ../dist/Layouts.alfredworkflow'
      },
      compileScreens: {
        command: 'gcc -o dist/screens -Wall -std=c99 lib/screens.m -framework Foundation -framework AppKit -lobjc',
        options: {
          stdout: true,
          stderr: true
        }
      },
      runScreens: {
        command: './dist/screens',
        options: {
          stdout: true,
          stderr: true
        }
      }
    },
    watch: {
      app: {
        files: '<%= concat.app.src %>',
        tasks: ['build']
      },
      runTest: {
        files: '<%= concat.app.src %>',
        tasks: [
          'build',
          'shell:test'
        ]
      },
      screens: {
        files: 'lib/screens.m',
        tasks: [
          'shell:compileScreens',
          'shell:runScreens'
        ]
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('default', ['build', 'alfred']);
  grunt.registerTask('build', ['concat', 'shell:compile', 'shell:compileScreens']);
  grunt.registerTask('test', ['default', 'shell:test']);
  grunt.registerTask('dev', ['watch:app']);
  grunt.registerTask('alfred', ['shell:alfred', 'shell:alfredVersion', 'shell:alfredZip']);
  grunt.registerTask('dev:screens', ['watch:screens']);
}
