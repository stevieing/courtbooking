@courts
Feature: Users should be able to browse the status of courts
  In order to book courts
  Any user
  Should be able to browse the courts and view bookings
  
  # The date and time must be set up before the courts.
  Background:
    Given todays date is "01 September 2013" and the time is "17:00"
    And the courts are setup and the peak hours settings are in place
  
  Scenario: Browsing the courts for today
    When I go to the courts page
    Then I should see a column for each court
    And I should see todays date
    
  Scenario: Browsing the courts for a time slot
    When I go to the courts page
    And I view the courts for tomorrow
    Then I should see a row for each time slot
    And I should be able to book each time slot for each court for today
    
  @split_opening_times
  Scenario: Browsing the courts during split opening times
    When I go to the courts page
    Then I should see a column for each court
    But I should not see a row for time slots where all the courts are closed
    
  Scenario: Browsing the calendar
    When I go to the courts page
    Then I should see a box for each day until a set day in the future
    And I should be able to select each day apart from today
    But I should not be able to view the courts beyond that date
    And I should not be able to view the courts before today
    
  Scenario: Browsing the courts for a time slot 5 days from today
    When I go to the courts page
    And I view the courts for 5 days from today
    Then I should be redirected to the courts page for that day
    And I should see the correct date
    
  Scenario: Browsing the courts when the dates are spread over 2 months
    When I go to the courts page
    And todays date is near the end of the month
    And I go to the courts page for that date
    Then the calendar should have an appropriate heading
    
  @opponent, @other_member  
  Scenario: Browsing the courts for existing bookings
    Given I am signed in
    When there are a number of valid bookings for myself and another member for the next day
    And I go to the courts page
    And I view the courts for tomorrow
    Then I should be able to edit my bookings
    But I should not be able to edit the bookings for another member
    
  Scenario: Bookings in the past
    Given I am signed in
    When there are two bookings one after the other for tomorrow
    And it is tomorrow after the first booking has started
    And I go to the courts page
    Then I should not be able to edit the first booking
    But I should be able to edit the second booking
    
  Scenario: Making a new booking
    Given I am signed in
    When I go to the courts page
    And I follow a link to create a new booking
    Then I should see valid booking details
    And I submit the booking
    Then I should see a message with the text Booking successfully created
    
  Scenario: Deleting a booking
    Given I am signed in
    And I have created a booking
    When I go to the courts page
    And I follow a link to edit the booking
    And I delete the booking
    Then I should see a message with the text Booking successfully deleted