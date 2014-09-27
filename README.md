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

Usual case is that the user creates a service. Then the user adds a container to that service. When the user adds a container
the system will want to fetch the description of that container so it can present the user with the options available to that
container. The system does the fetching by having a primary provisioner configured. This is the only reason to have a primary
provisioner. What we could alternatively do is just git clone the repo and read it ourselves. The advantage is that we don’t
have to configure a local provisioner, the disadvantage is that this API will have to be capable of any technologies the
provisioner is capable of for acquiring container descriptions.

We could do:

    mkdir /tmp/redis-container-6d25361d
    cd /tmp/redis-container-6d25361d
    git clone -n --depth=1 git@github.com:d-snp/redis-container.git
    git checkout HEAD twistlock.yml
    cat twistlock.yml && rm -rf /tmp/redis-container-6d25361d


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
