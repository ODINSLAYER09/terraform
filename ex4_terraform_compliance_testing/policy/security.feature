Feature: Security and Compliance Rules
  As a security engineer
  I want to ensure all infrastructure follows our policies
  So that we maintain security and governance standards

  Scenario: Ensure all resources have a Department tag
    Given I have resource that supports tags defined
    Then it must contain tags
    And it must contain "Department"

  Scenario: Ensure storage accounts do not have public network access
    Given I have azurerm_storage_account defined
    Then it must contain public_network_access_enabled
    And its value must be false