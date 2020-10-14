Feature: Add user
  As an admin
  I want to add users
  So that the authorized access is possible

  Scenario: Admin adds user without permission
    Given the user with login "harrypotter@gmail.com" does not exist
    When the admin creates user with following details using API
      | last name | Potter                |
      | login     | harrypotter@gmail.com |
      | password  | password              |
    Then the response status code should be "200"
    And user with login "harrypotter@gmail.com" should exist

  Scenario: Admin creates already existing user
    Given the admin has created the following users
      | login | last name | password |
      | Harry | Potter    | hello123 |
    When the admin creates user with following details using API
      | last name | Potter |
      | login     | Harry  |
    Then the response status code should be "500"
    And the response message should be "ErrorLoginAlreadyExists"

  Scenario Outline: Admin adds user with incomplete essential credentials
    Given the user with login "Harry" does not exist
    When the admin creates user with following details using API
      | last name | <last name> |
      | login     | Harry       |
      | password  | <password>  |
    Then the response status code should be "200"
    And user with login "Harry" should exist
    Examples:
      | last name | password   |
      |           |            |
      | Joseph    |            |
      |           | Helloworld |

  Scenario Outline: Admin adds user without login information
    Given the user with login "Harry" does not exist
    When the admin creates user with following details using API
      | last name | <last name> |
      | login     |             |
      | password  | <password>  |
    Then the response status code should be "500"
    And the response message should be "Field 'Login' is required"
    Examples:
      | last name | password   |
      | Joseph    |            |
      |           | Helloworld |
      | Joseph    | helloworld |

  Scenario Outline: Admin adds user with last name as special characters
    Given the user with login "<login>" does not exist
    When the admin creates user with following details using API
      | last name | <last name> |
      | login     | <login>     |
      | password  | password    |
    Then the response status code should be "200"
    And user with login "<login>" should exist
    Examples:
      | last name                  | login                  |
      | swi@                       | $w!kr!t!               |
      | g!!@%ui                    | España§àôœ€            |
      | swikriti@h                 | नेपाली                 |
      | !@#$%^&*()-_+=[]{}:;,.<>?~ | सिमप्ले $%#?&@name.txt |

