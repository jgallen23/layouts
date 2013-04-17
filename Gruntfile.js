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
        command: 'cp -v <%= compiledDist %> alfred-workflow/',
        options: {
          stdout: true
        }
      },
      alfredVersion: {
        command: 'sed -i "" "s/Simple Window Manager.*</Simple Window Manager v<%= info.version %></" alfred-workflow/info.plist'
      },
      alfredZip: {
        command: 'cd alfred-workflow/ && zip tmp * && mv tmp.zip ../dist/Layouts.alfredworkflow'
      }
    },
    watch: {
      app: {
        files: '<%= concat.app.src %>',
        tasks: ['build']
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('default', ['build', 'alfred']);
  grunt.registerTask('build', ['concat', 'shell:compile']);
  grunt.registerTask('test', ['default', 'shell:test']);
  grunt.registerTask('dev', ['watch:app']);
  grunt.registerTask('alfred', ['build', 'shell:alfred', 'shell:alfredVersion', 'shell:alfredZip']);
}
