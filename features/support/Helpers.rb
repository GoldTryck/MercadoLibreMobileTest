module Helpers
  def wait_for(by:, locator:, timeout: 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    wait.until do
      element = driver.find_element(by, locator)
      element.displayed? && element.enabled? ? element : nil
    end
  rescue Selenium::WebDriver::Error::TimeoutError
    raise "Elemento no encontrado o no accesible: #{by} => #{locator} después de #{timeout} segundos"
  rescue StandardError => e
    raise "Error al esperar el elemento: #{e.message}"
  end

  def doScroll()
    size = driver.window_size
    start_x = (size.width / 4) * 3
    start_y = (size.height / 10) * 9
    end_y = size.height / 10

    puts "Desplazando desde (#{start_x}, #{start_y}) hasta (#{start_x}, #{end_y})"

    finger = driver.action.add_pointer_input(:touch, 'finger1')
    finger.create_pointer_move(x: start_x, y: start_y, duration: 0, origin: :viewport)
    finger.create_pointer_down(:left)
    finger.create_pointer_move(x: start_x, y: end_y, duration: 2, origin: :viewport)
    finger.create_pointer_up(:left)
    driver.perform_actions([finger])
  end
end
