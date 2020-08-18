Feature: user login
  As a user/admin
  I want to login to my account
  So that I can have access to my functionality

  Background:
    Given the user has browsed to the login page

  Scenario: Admin user should be able to login successfully
    When user enters username "dolibarr" and password "password"
    And user clicks the login button
    Then the user should be directed to the homepage

  Scenario: Admin user with empty credentials should not be able to login
    When user enters username "" and password ""
    And user clicks the login button
    Then the user should not be able to login

  Scenario Outline: user logs in with invalid credentials
    When user enters username "<username>" and password "<password>"
    And user clicks the login button
    Then the user should not be able to login
    And the error message "Bad value for login or password" should be displayed
    Examples:
      | username | password |
      | dolibar  | pass     |
      | dolibarr | passw    |
      | dolibar  |          |
      | dolibarr |          |
      | dolibar  | password |




#Scenario: Admin user with wrong credentials should not be able to login
#When user enters username "dolibar" and password "pasword"
#And user clicks the login button
#Then the user should not be able to login
#And the error message "Bad value for login or password" should be displayed

#Scenario: Admin user with wrong username should not be able to login
#When user enters username "dolibar" and password "password"
#And user clicks the login button
#Then the user should not be able to login
#And the error message "Bad value for login or password" should be displayed
#
#Scenario: Admin user with wrong password should not be able to login
#When user enters username "dolibarr" and password "passwor"
#And user clicks the login button
#Then the user should not be able to login
#And the error message "Bad value for login or password" should be displayed




