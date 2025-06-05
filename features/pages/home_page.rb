class HomePage
  include Helpers

  def initialize(driver)
    @driver = driver
  end
  
  def search_for(term)
    wait_for(by: :id, locator: 'com.mercadolibre:id/ui_components_toolbar_title_toolbar')
    @driver.find_element(id: 'com.mercadolibre:id/ui_components_toolbar_title_toolbar').click
    wait_for(by: :xpath, locator: '//android.widget.EditText[@resource-id="com.mercadolibre:id/autosuggest_input_search"]')
    @driver.find_element(xpath: '//android.widget.EditText[@resource-id="com.mercadolibre:id/autosuggest_input_search"]').send_keys(term)
    @driver.press_keycode(66)
    sleep 2
  end
end