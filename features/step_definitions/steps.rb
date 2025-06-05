require_relative '../pages/home_page.rb'
require_relative '../pages/results_page.rb'

When(/^I search for '(.+)'$/) do |product|
  @home_page = HomePage.new(driver)
  @home_page.search_for(product)
end

When(/^I filter by condition '(.+)'$/) do |condition|
  @results_page = ResultsPage.new(@driver)
  @results_page.add_filter("Condición", condition)
  
end

When(/^I filter by location '(.+)'$/) do |location|
  # Not havve a location filter in the app
end

When(/^I sort by price '(.+)'$/) do |sort_order|
  @results_page.add_filter("Ordenar por", sort_order)
end
Then('I apply the filters') do
  @results_page.apply_filters()
end

Then('I should see the name and price of the first 5 products') do
  @results_page.print_first_five_results()
end
