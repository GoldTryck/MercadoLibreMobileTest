Feature: Search and filter products on Mercado Libre
  As a Mercado Libre user
  I want to search and filter products
  So I can find the best deals matching my criteria

  Scenario Outline: Search for <product> with filters
    When I search for '<product>'
    And I filter by condition '<condition>'
    And I filter by location '<location>'
    And I sort by price '<sort_order>'
    Then I apply the filters
    And I should see the name and price of the first 5 products

    Examples:
      | product        | condition | location         | sort_order   |
      | Play Station 5 | Nuevo     | Distrito Federal | Mayor precio |