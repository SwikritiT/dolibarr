Feature: Add user
  As an admin
  I want to add users
  So that the authorized access is possible

  Background:
    Given the administrator has logged in using the web UI
    And the administrator has browsed to the new users page

  Scenario: Admin adds user without permission
    Given the administrator has logged in using the web UI
    And the administrator has browsed to the new users page
    When the admin creates user with last name following details
      | last name | Tripathi              |
      | login     | swikriti808@gmail.com |
      | password  | password              |
    Then new user "Tripathi" should be created
    And the message "This user has no permissions defined" should be displayed

  Scenario Outline: Admin adds user with permission
    When the admin creates user with following details
      | last name     | Tripathi              |
      | login         | swikriti808@gmail.com |
      | password      | password              |
      | administrator | <administraror>       |
      | gender        | <gender>              |
    Then the message "This user has no permissions defined" <shouldOrShouldNot> displayed
    And new user "Tripathi" should be created
    Examples:
      | administrator | gender | shouldOrShouldNot |
      | no            |        | should            |
      | no            | man    | should            |
      | no            | woman  | should            |
      | yes           |        | should not        |
      | yes           | man    | should not        |
      | yes           | woman  | should not        |

  Scenario Outline: Admin adds user with last name as special characters
    When the admin creates user with following details
      | last name     | #@hsish         |
      | login         | 123456          |
      | password      | password        |
      | administrator | <administraror> |
      | gender        | <gender>        |
    Then the message "This user has no permissions defined" <shouldOrShouldNot> displayed
    And new user "Tripathi" should be created
    Examples:
      | administrator | gender | shouldOrShouldNot |
      | no            |        | should            |
      | no            | man    | should            |
      | no            | woman  | should            |
      | yes           |        | should not        |
      | yes           | man    | should not        |
      | yes           | woman  | should not        |

  Scenario Outline: Admin adds user with incomplete essential credentials
    When the admin creates user with following details
      | last name | <lastname> |
      | login     | <e-mail>   |
      | password  | <password> |
    Then the message <message> should be displayed
    And new user "<lastname>" shouldn't be created
    Examples:
      | last name | login        | password | message                                    |
      |           |              |          | Name is not defined. Login is not defined. |
      | Tripathi  |              |          | Login is not defined.                      |
      |           | hi@gmail.com |          | Name is not defined.                       |
      | Tripathi  |              | hihi     | Login not defined                          |

  @issue
  Scenario: Admin adds user with incomplete essential credentials
    When the admin creates user with following details
      | last name | Tripathi              |
      | login     | swikriti808@gmail.com |
      | password  |                       |
    Then the message "This user has no permissions defined." should be displayed
    And new user "Tripathi" should be created









