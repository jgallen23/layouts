module.exports = function(grunt) {
  grunt.initConfig({
    doc: 'index.md',
    watch: {
      md: {
        files: '<%= doc %>',
        tasks: 'default'
      }
    },
    connect: {
      server: {
        port: 8000,
        base: '.'
      }
    },
    shell: {
      build: {
        command: 'ghpage <%= doc %>',
        options: {
          stdout: true
        }
      }
    },
    reloadr: {
      main: [
        'index.html'
      ]
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-reloadr');

  grunt.registerTask('default', ['shell:build']);
  grunt.registerTask('dev', ['connect:server', 'reloadr', 'watch']);
};
