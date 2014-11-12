import Ember from 'ember';

var ApplicationController = Ember.Controller.extend({

  currentYear: function(){
    return moment().year();
  }.property("currentYear")

});

export default ApplicationController;
