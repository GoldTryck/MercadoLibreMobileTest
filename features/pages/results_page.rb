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
      return if processed >= 5

      first_result = @driver.find_element(xpath: "//*[@resource-id='com.mercadolibre:id/search_component_compose_view']/android.view.View/android.view.View/android.view.View")

      text_views = first_result.find_elements(xpath: ".//android.widget.TextView")
      price_el = text_views.find { |el| el.attribute("resource-id")&.include?("money_amount_text") }
      price = price_el&.attribute("text")

      title = nil
      title = text_views.find do |el|
        text = el.attribute("text")&.strip
        next if text.nil? || text.empty?
        next if text == text.upcase
        next if text.include?("$")
        normalized_text = text.downcase.gsub(/\s+/, "")
        normalized_term = browse_term.downcase.gsub(/\s+/, "")
        next unless normalized_text.include?(normalized_term)
        true
      end&.attribute("text")

      puts "Título: #{title} | Precio: #{price}"
      processed += 1
      return if processed >= 5
      scroll_up_until_element_fully_out(first_result)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      next
    end
  end

  # To implement for compare the text of the elements with the search text
  # This method will validate that all elements contain the search text
  # It will return true if all elements match, otherwise false
  def validate_results(search_text, elements)
    elements.all? do |element|
      text = element.text.downcase
      text.include?(search_text.downcase)
    end
  end

  def fully_out_of_view?(element)
    begin
      rect = element.rect
      screen_height = @driver.window_size.height
      screen_width = @driver.window_size.width

      # Consideramos fuera si el elemento está completamente arriba, abajo, izquierda o derecha fuera de la pantalla
      completely_above = (rect[:y] + rect[:height]) < 0
      completely_below = rect[:y] > screen_height
      completely_left  = (rect[:x] + rect[:width]) < 0
      completely_right = rect[:x] > screen_width

      completely_above || completely_below || completely_left || completely_right
    rescue Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::NoSuchElementError
      # Si el elemento no existe o está stale, lo consideramos fuera
      true
    end
  end

  def scroll_up_until_element_fully_out(element, max_attempts = 20)
    attempts = 0
    screen_width = @driver.window_size.width
    screen_height = @driver.window_size.height

    swipe_distance = (screen_height * 0.1).to_i

    until fully_out_of_view?(element) || attempts >= max_attempts
      start_x = screen_width / 2
      start_y = (screen_height * 0.8).to_i
      end_y = start_y - swipe_distance         

    finger = driver.action.add_pointer_input(:touch, 'finger1')
    finger.create_pointer_move(x: start_x, y: start_y, duration: 0, origin: :viewport)
    finger.create_pointer_down(:left)
    finger.create_pointer_move(x: start_x, y: end_y, duration: 2, origin: :viewport)
    finger.create_pointer_up(:left)
    driver.perform_actions([finger])

      sleep 0.5

      attempts += 1
    end

    fully_out_of_view?(element)
  end

end
