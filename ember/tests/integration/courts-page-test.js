import startApp from '../helpers/start-app';
import loadSlots from '../fixtures/slots';

var App, server, calendar;

module('Integration - Courts Page', {
  setup: function(){
    App = startApp();
    server = new Pretender();
  },

  teardown: function(){
    Ember.run(App, 'destroy');
    server.shutdown();
  }
});