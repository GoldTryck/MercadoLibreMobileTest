# Mercado libre mobile test

This project is an automated testing suite for Android devices, built using **Ruby**, **Appium**, and **Cucumber**.

## Prerequisites

- [Ruby](https://www.ruby-lang.org/) >= 3.4.4
- [Bundler](https://bundler.io/)
- [Appium](https://appium.io/) server installed and running
- Android device or emulator with developer mode enabled
- [Android SDK](https://developer.android.com/studio) installed and configured

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/GoldTryck/MercadoLibreMobileTest
    cd MercadoLibreMobileTest
    ```

2. Install Ruby dependencies:
    ```bash
    bundle install
    ```

## Setup Capabilities

Before running the tests, configure your desired capabilities for Appium. Edit the configuration file (commonly found at `features/support/appium.txt` or similar) to match your device/emulator settings. Example:

```ruby
caps = {
  platformName: "Android",
  deviceName: "Yoyr device name,
  udid: DEVICE_UDID
}
```

Adjust the values as needed for your environment.

## Running the Tests

1. Start the Appium server:
    ```bash
    appium
    ```

2. Connect your Android device or start an emulator.

3. Execute the test suite:
    ```bash
    bundle exec cucumber
    #or
    cucumber
    ```

## Reports
To generate a report of the test execution, run:

```bash
cucumber --publish
```

Test results will be displayed in the terminal.

## Project Structure

```
MercadoLibreMobileTest/
├── features/
│   ├── step_definitions/
│   ├── support/
    ├──pages/
│   └── *.feature
├── Gemfile
├── .gitignore
└── README.md
```

## Contributing

1. Fork the repository.
2. Create a branch (`git checkout -b feature/new-feature`).
3. Make your changes and commit (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

