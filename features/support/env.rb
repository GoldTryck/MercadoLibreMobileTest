require 'appium_lib'
require 'cucumber'

caps = {
  caps: {
    platformName: 'Android',
    automationName: 'UiAutomator2',
    deviceName: 'Android',
    udid: 'A4NDU19A24003758',
    appPackage: 'com.mercadolibre',
    appActivity: 'com.mercadolibre.splash.SplashActivity',
    noReset: true,
    waitForIdleTimeout: 1000,
  },
  
  
}

$driver = Appium::Driver.new(caps, true)
$driver.start_driver
Appium.promote_appium_methods Object

