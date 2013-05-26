Feature: Users should be able to browse the status of courts
  In order to book courts
  Any user
  Should be able to browse the current status of each court
  
  Background:
    Given there are 4 courts
    And the courts are available from "06:20" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And the peak hours are "17:40" and "20:20"
    And no more than 3 courts can be booked during peak times
    And todays date is "01 September 2013"
    And todays date and time is "01 September 2013 09:00"
  
  Scenario: Browsing the courts for today
    When I go to the courts page
    Then I should see a column for each court
    And I should see "01 Sep 2013"
    
  Scenario: Browsing the courts for a time slot
    When I go to the courts page
    And I click the "02" link on the calendar
    Then I should see a row for each time slot
    And I should see a link to book each time slot for each court for "02 September 2013"
    
  Scenario: Browsing the courts for the days I can book a court
    When I go to the courts page
    Then I should see a box for date "01"
    And I should not see a link to "01" on the calendar
    And I should see a box for each day for the next 20 days
    And I should not see a link which is 22 days after today
    And I should not see a link which is 2 days before today
    And I should see a header with "September 2013"
    
  Scenario: Browsing the courts for a time slot 5 days from today
    When I go to the courts page
    Then I should see a box for date "06"
    And I click the "06" link on the calendar
    And I should be redirected to the courts page with date "06 September 2013"
    And I should see "06 Sep 2013"
    And I should see "06"
    And I should not see a link to "06" on the calendar
    
  Scenario: Browsing the courts when the dates are spread over 2 months
    Given todays date is "20 September 2013"
    When I go to the courts page with date "31 September 2013"
    Then I should see a header with "September -> October 2013"
    
  Scenario: Browsing the courts for existing bookings
    Given a standard user exists with id: 999 and username: "joebloggs" and password: "password"
    And a standard user exists with id: 111 and username: "worthy opponent" and email: "worthyopponent@example.com"
    And a standard user exists with id: 222 and username: "Nicol David" and email: "nicodavid@example.com"
    And there is a booking with user_id: 999 and court_number: 1 and booking_date_and_time: "01 September 2013 12:00"
    And there is a booking with user_id: 999 and opponent_user_id: 111 and court_number: 2 and booking_date_and_time: "01 September 2013 19:00"
    And there is a booking with user_id: 222 and court_number: 4 and booking_date_and_time: "01 September 2013 19:40"
    And there is a booking with user_id: 222 and opponent_user_id: 111 and court_number: 3 and booking_date_and_time: "01 September 2013 19:00"
    Given I login as "joebloggs" with password "password"
    When I go to the courts page
    Then I should see a link to "joebloggs" within the bookings
    And I should see a link to "joebloggs V worthy opponent" within the bookings
    And I should see "Nicol David" within the bookings
    And I should not see a link to "Nicol David" within the bookings
    And I should see "Nicol David V worthy opponent" within the bookings
    And I should not see a link to "Nicol David V worthy opponent" within the bookings
    
  Scenario: Bookings in the past
    Given a standard user exists with id: 999 and username: "joebloggs" and password: "password"
    And a standard user exists with id: 111 and username: "worthy opponent" and email: "worthyopponent@example.com"
    And a standard user exists with id: 222 and username: "Nicol David" and email: "nicodavid@example.com"
    And there is a booking with user_id: 999 and opponent_user_id: 111 and court_number: 1 and booking_date_and_time: "02 September 2013 19:00"
    And there is a booking with user_id: 999 and opponent_user_id: 222 and court_number: 2 and booking_date_and_time: "02 September 2013 20:20"
    And todays date and time is "02 September 2013 19:40"
    Given I login as "joebloggs" with password "password"
    When I go to the courts page
    And I click the "02" link on the calendar
    Then I should not see a link to "joebloggs V worthy opponent" within the bookings
    And I should see a link to "joebloggs V Nicol David" within the bookings
    And I should not see a link to "1 - 02 September 2013 12:20"
    
   
    
    