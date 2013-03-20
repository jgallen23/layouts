module.exports = function(grunt) {
  grunt.initConfig({
    dist: 'dist/layouts.applescript',
    compiledDist: 'dist/layouts.scpt',
    concat: {
      app: {
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
      }
    },
    watch: {
      app: {
        files: '<%= concat.app.src %>',
        tasks: [
          'concat:app',
          'shell:compile'
        ]
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('default', ['concat', 'shell:compile']);
  grunt.registerTask('test', ['default', 'shell:test']);
  grunt.registerTask('dev', ['watch:app']);
  grunt.registerTask('alfred', ['default', 'shell:alfred']);
}
