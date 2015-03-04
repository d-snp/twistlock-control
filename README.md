# TwistlockControl

The Twistlock Control system.

## Installation

Add this line to your application's Gemfile:

    gem 'twistlock-control'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twistlock-control

## Usage

The TwistlockControl system has a user interface called Rotterdam. Rotterdam executes
the logic functions in here to manipulate the Twistlock provisioners. 

Actions that Rotterdam needs that this library implements:

  * Defining services
  * Importing container descriptions
  * Creating service instances
  * Configuring service instances
  * Adding provisioners
  * Provisioning service instances on provisioners

To aid these actions, Rotterdam needs to subscribe to the following resources:

  * Defined services
  * Imported container descriptions
  * Service instances
  * Provisioners
  * Container instances

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
