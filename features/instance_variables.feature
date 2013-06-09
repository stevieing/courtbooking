@instance_variables
Feature: Instance Variables
  In order to ensure the instance variables are set up
  A helper
  Should do some magic
    
  Background:
    Given the courts are setup and the peak hours settings are in place
    
  Scenario: Set up simple instance variables
    Given there is a rails configuration value for days bookings can be made in advance
    When I set up days that bookings can be made in advance through a helper method
    Then it should return the correct value
    
  Scenario: Set up complex instance variables
    Given there is a helper class for date utils
    When I set up a date utils instance
    And I set up the helper method
    Then it should contain the correct values
    
  Scenario: Change the value of the instance variable from a method
    Given there is a current booking instance variable
    When I change the value of the booking instance variable
    Then the booking should be the one I just added