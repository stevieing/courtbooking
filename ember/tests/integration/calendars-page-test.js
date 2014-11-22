import startApp from '../helpers/start-app';
import loadCalendar from '../fixtures/calendar';

var App, server, calendar;

module('Integration - Calendars Page', {
  setup: function(){
    App = startApp();
    calendar = loadCalendar();

    server = new Pretender(function(){
      this.get('api/calendars/:date', function(request){
        return [200, {"content-Type": "application/json"}, JSON.stringify({calendar: calendar})];
      });
    });
  },

  teardown: function(){
    Ember.run(App, 'destroy');
    server.shutdown();
  }
});

test("Should contain the correct title", function(){
  visit('/calendars/2014-11-17').then(function(){
    equal(find('caption').text(), calendar.table.heading);
  });
});