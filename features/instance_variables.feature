@instance_variables
Feature: Instance Variables
  In order to ensure the instance variables are set up
  A helper
  Should do some magic

  Background:
    Given the courts are setup

  Scenario: Set up simple instance variables
    Given there is a configuration value for days bookings can be made in advance
    When I set up days that bookings can be made in advance through a helper method
    Then it should return the correct value

  Scenario: Change the value of the instance variable from a method
    Given there is a current booking instance variable
    When I change the value of the booking instance variable
    Then the booking should be the one I just added