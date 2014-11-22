import startApp from '../helpers/start-app';

var App;

module('Integration - Home Page', {
  setup: function(){
    App = startApp();
  },
  teardown: function(){
    Ember.run(App, 'destroy');
  }
});

test("Should contain a copyright message", function(){
  visit('/').then(function(){
    var text = '\u00A9 Stamford Squash Club ' + moment().year();
    equal(find('.copyright:contains(' + text + ')').length, 1);
  });
});

test("Should navigate to the courts page", function(){
  visit('/').then(function(){
    click("a:contains('COURTS')").then(function(){
      equal(find('h2').text(),'Courts');
    });
  });
});

test("Should navigate to the bookings page", function(){
  visit('/').then(function(){
    click("a:contains('BOOKINGS')").then(function(){
      equal(find('h2').text(),'Bookings');
    });
  });
});

test("Should navigate to the sign in page", function(){
  visit('/').then(function(){
    click("a:contains('SIGN IN')").then(function(){
      equal(find('h2').text(),'Sign In');
    });
  });
});