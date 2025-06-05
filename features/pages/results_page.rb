require 'rubygems'
require 'appium_lib'

class ResultsPage
  include Helpers

  def initialize(driver)
    @driver = driver
  end

  def add_filter(criteria, value)
    sleep 2
    @driver.find_element(xpath: '//*[contains(@text, "Filtros")]').click
    if swipe_until_visible(criteria)
      @driver.find_element(xpath: "//*[@text='#{criteria}']").click
      wait_for(by: :xpath, locator: "//*[@text='#{value}']")
      @driver.find_element(xpath: "//*[@text='#{value}']").click
      
    else
      raise "No se pudo aplicar el filtro: #{criteria}. Elemento no encontrado."
    end
  end

  def apply_filters
    wait_for(by: :xpath, locator: "//*[contains(@text, 'Ver ') and contains(@text, ' resultados')]")
    @driver.find_element(xpath: "//*[contains(@text, 'Ver ') and contains(@text, ' resultados')]").click
  end


  def swipe_until_visible(element_text)
    tries = 20

    while tries > 0
      begin
        element = @driver.find_element(xpath: "//*[@text='#{element_text}']")
        if element.displayed?
          return true
        end
      rescue Selenium::WebDriver::Error::NoSuchElementError
        puts "Elemento '#{element_text}' no encontrado."
      end
      doScroll()
      tries -= 1
    end

    puts "No se encontró el elemento '#{element_text}' tras hacer scroll."
    false
  end
  
  def print_first_five_results
    processed = 0
    browse_term = @driver.find_element(xpath: "//*[contains(@resource-id, 'ui_components_toolbar_title_toolbar')]").attribute("text")
    loop do
      visible_results = @driver.find_elements(xpath: "//*[@resource-id='com.mercadolibre:id/search_component_compose_view']/android.view.View/android.view.View/android.view.View")
      puts "Elementos visibles en esta iteración: #{visible_results.size}"

      visible_results.each do |result|
        begin
          text_views = result.find_elements(xpath: ".//android.widget.TextView")
  
          price_el = text_views.find { |el| el.attribute("resource-id")&.include?("money_amount_text") }
          price = price_el&.attribute("text")

          title = nil
          index_price = text_views.index(price_el)
  
          candidates = index_price ? text_views[0...index_price].reverse : text_views.reverse
          title = candidates.find do |el|
            text = el.attribute("text")&.strip
            next if text.nil? || text.empty?
            next if text == text.upcase
            next if text.downcase.match?(/mes|env[ií]o|cuotas|inter[eé]s/)
  
            true
          end&.attribute("text")
  
          puts "Título: #{title} | Precio: #{price}"
          processed += 1
          return if processed >= 5
  
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          next
        end
      end
  
      break if processed >= 5
  
      doScroll()
      sleep 1
    end
  end
  
  # To implemen for compare the text of the elements with the search text
  # This method will validate that all elements contain the search text
  # It will return true if all elements match, otherwise false
  # This method will validate that all elements contain the search text
  # It will return true if all elements match, otherwise false
  def validate_results(search_text, elements)
    elements.all? do |element|
      text = element.text.downcase
      text.include?(search_text.downcase)
    end
  end
  

end
  