Feature: Provisioning service instances

	In order for the user to make use of a service instance, it has to be
	provisioned on a machine that's connected to Twistlock.

	Scenario: A simple one-container service

		Given a user has defined a service
		Given a provisioner is configured
		And a user has created an instance of that service
		Then the user should be presented with a configurable representation of the service
		When the user configures the service instance
		And the user gives the provision command
		Then a container instance should be provisioned
