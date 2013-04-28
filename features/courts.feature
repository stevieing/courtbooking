Feature: Users should be able to browse the status of courts
  In order to book courts
  Any user
  Should be able to browse the current status of each court
  
  Background:
    Given there are 4 courts
    And the courts are available from "06:40" to "22:00" with a 40 minute time slot
    And the courts can be booked up to 3 weeks in advance
    And todays date is "01 September 2013"
  
  Scenario: Browsing the courts for today
    When I go to the courts page
    Then I should see a column for each court
    And I should see "01 Sep 2013"
    
  Scenario: Browsing the courts for a time slot
    When I go to the courts page
    Then I should see a row for each time slot
    And I should see a time slot for each court
    
  Scenario: Browsing the courts for the days I can book a court
    When I go to the courts page
    Then I should see a box for date "01"
    And I should not see a link to "01"
    And I should see a box for each day for the next 20 days
    And I should not see a link which is 22 days after today
    And I should not see a link which is 2 days before today
    And I should see a header with "September 2013"
    
  Scenario: Browsing the courts for a time slot 5 days from today
    When I go to the courts page
    Then I should see a box for date "06"
    And I click the "06" link 
    And I should be redirected to the courts page with date "06 September 2013"
    And I should see "06 Sep 2013"
    And I should see "06"
    And I should not see a link to "06"
    
  Scenario: Browsing the courts when the dates are spread over 2 months
    Given todays date is "20 September 2013"
    When I go to the courts page with date "31 September 2013"
    Then I should see a header with "September -> October 2013"
    
  
    
