#OAuth2

- Get familiar with OmniAuth by Intridea: http://github.com/intridea/omniauth. Read about OAuth2.
- Obtain client_id and client_secret for your app from Exvo.
- Install exvo-auth gem or add it to your Gemfile.


##Configure middleware.

In Rails, the relevant lines could look like this:

    ExvoAuth::Config.client_id     = "foo"
    ExvoAuth::Config.client_secret = "bar"
    ExvoAuth::Config.debug         = true # dumps all HTTP traffic to STDERR, useful during development.
    config.middleware.use ExvoAuth::Middleware


##Add routes.

The following comes from Rails config/routes.rb file:

    match "/auth/failure"                  => "sessions#failure"
    match "/auth/interactive/callback"     => "sessions#create"
    match "/auth/non_interactive/callback" => "sessions#create" # only if you use json-based login
    match "/sign_out"                      => "sessions#destroy"

Failure url is called whenever there's a failure (d'oh).
You can have separate callbacks for interactive and non-interactive
callback routes but you can also route both callbacks to the same controller method
like shown above.

##Include controller helpers into your application controller.

    include ExvoAuth::Controllers::Rails (or Merb)

##Implement a sessions controller.

Sample implementation (Rails):

    class SessionsController < ApplicationController
      def create
        sign_in_and_redirect!
      end

      def destroy
        sign_out_and_redirect!
      end

      def failure
        render :text => "Sorry!"
      end
    end

##Implement #find_or_create_user_by_uid(uid) in your Application Controller.

This method will be called by #current_user. Previously we did this in sessions_controller but since the sharing sessions changes this controller
will not be used in most cases because the session comes from another app through a shared cookie. This method should find user by uid or create it.
Additional info (emails, etc) can be obtained using auth api (/users/uid.json path).

In short: you get params[:auth]. Do what you want to do with it: store the data, create session, etc.


##Sign up and sign in paths for use in links.

    sign in path:                       "/auth/interactive"
    sign up path:                       "/auth/interactive?x_sign_up=true" # this is OAuth2 custom param
    sign in path with a return address: "/auth/interactive?state=url"      # using OAuth2 state param

You have a handy methods available in controllers (and views in Rails): sign_in_path and sign_up_path.

##Read the source, there are few features not mentioned in this README.


#Inter-Application Communication

You need to have "App Authorization" created by Exvo first.
Contact us and provide following details:

- consumer_id - Id of an app that will be a consumer (this is you)
- provider_id - Id of the provider app
- scope       - The tag associated with the api you want to use in the provider app

##Consumer side

    consumer = ExvoAuth::Autonomous::Consumer.new(
      :app_id => "this is client_id of the app you want to connect to"
    )
    consumer.get(*args) - interface is exactly the same like in HTTParty. All http methods are available (post, put, delete, head, options).

##Provider side

See #authenticate_app_in_scope!(scope) method in ExvoAuth::Controllers::Rails (or Merb). This method lets you create a before filter.
Scopes are used by providing app to check if a given consuming app should have access to a given resource inside a scope.
If scopes are empty, then provider app should not present any resources to consumer.

##Example of the before filter for provider controller:

    before_filter {|c| c.authenticate_app_in_scope!("payments") }

In provider controller which is just a fancy name for API controller you can use #current_app_id method to get the app_id of the app connecting.


#Dejavu - replay non-GET requests after authentication redirects

##Limitations:

- doesn't work with file uploads
- all request params become query params when replayed
