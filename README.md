# exvo-auth

This gem is Exvo's implementation of the oauth2 protocole for handling user authentication across Exvo apps.



## Requirements

* Runs on Ruby 1.8.7 & 1.9.2 (preferred version)
* Rails 3.0+ (works with Rails 3.1) or Merb



## OAuth2

* Get familiar with [OmniAuth by Intridea](http://github.com/intridea/omniauth). Read about OAuth2.
* Obtain `client_id` and `client_secret` for your app from Exvo.
* Install `exvo-auth` gem and add it to your Gemfile.



## Middleware configuration

The preferred way to configure the gem is via the ENV variables:

```ruby
ENV['AUTH_CLIENT_ID']     = "foo"
ENV['AUTH_CLIENT_SECRET'] = "bar"
ENV['AUTH_DEBUG']         = true            # [OPTIONAL] dumps all HTTP traffic to STDERR, useful during development
ENV['AUTH_REQUIRE_SSL']   = false           # [OPTIONAL] disable SSL, useful in development (note that all apps API urls must be http, not https)
ENV['AUTH_HOST']          = "test.exvo.com" # [OPTIONAL] override the default auth host
```

Then add this line to `config/application.rb`:

```ruby
config.middleware.use ExvoAuth::Middleware
```

But you can also set things directly in the `config/application.rb` file (before the middleware declaration):

```ruby
ExvoAuth::Config.client_id     = "foo"
ExvoAuth::Config.client_secret = "bar"
ExvoAuth::Config.debug         = true
ExvoAuth::Config.require_ssl   = false
ExvoAuth::Config.host          = "test.exvo.com"
```


## Add routes

The following comes from Rails `config/routes.rb` file:

```ruby
match "/auth/failure"                  => "sessions#failure"
match "/auth/interactive/callback"     => "sessions#create"
match "/auth/non_interactive/callback" => "sessions#create" # only if you use json-based login
match "/sign_out"                      => "sessions#destroy"
```

Failure url is called whenever there's a failure (d'oh).

You can have separate callbacks for interactive and non-interactive callback routes but you can also route both callbacks to the same controller method like shown above.


## Include controller helpers into your application controller

```ruby
include ExvoAuth::Controllers::Rails # (or Merb)
```


## Implement a sessions controller

Sample implementation (Rails):

```ruby
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
```

It's good to have your SessionsController#create action a little more extended, so that each time the user logs in into the app, his user data (like email, nickname) is updated from auth (his profile):

```ruby
def create
  auth = request.env["omniauth.auth"]

  if user = User.find_by_uid(auth["uid"])
    user.update_attributes!(auth["user_info"])
  else
    user = User.create(:uid => auth["uid"], :nickname => auth["user_info"]["nickname"], :email => auth["user_info"]["email"])
  end

  sign_in_and_redirect!
end
```

This is what you get (and what you can use/save for the local user) from auth (example data as of 2011-12):

```ruby
request.env["omniauth.auth"].inspect

  { "provider" => "exvo",
    "uid" => 1,
    "credentials" => {
      "token" => "a2d09701559b9f26a8284d6f94670477d882ad6d9f3d92ce9917262a6b54085fa3fb99e111340459"
    },
    "user_info" => {
      "nickname" => "Pawel",
      "email" => "pawel@exvo.com"
    },
    "extra" => {
      "user_hash" => {
        "id" => 1,
        "nickname" => "Pawel",
        "country_code" => nil,
        "plan" => "admin",
        "language" => "en",
        "email" => "pawel@exvo.com",
        "referring_user_id" => nil
      }
    }
  }
```


## Implement `#find_or_create_user_by_uid(uid)` in your Application Controller

This method will be called by `#current_user`. Previously we did this in `sessions_controller` but since the sharing sessions changes this controller will not be used in most cases because the session comes from another app through a shared cookie. This method should find user by uid or create it.

Exemplary implementation (Rails):

```ruby
def find_or_create_user_by_uid(uid)
  User.find_or_create_by_uid(uid)
end
```

It's best to leave this method as it is (without updating any user data inside this method, better to do this in the SessionsController#create action). Updating user in this method might lead to some very hard to debug cyclic executions possibly leading to stack-level too deep errors and/or general slowness, so please proceed with extreme caution.


## Sign up and sign in paths for use in links

```ruby
sign in path:                       "/auth/interactive"
sign up path:                       "/auth/interactive?x_sign_up=true" # this is OAuth2 custom param
sign in path with a return address: "/auth/interactive?state=url"      # using OAuth2 state param
```

You have a handy methods available in controllers (and views in Rails): `sign_in_path` and `sign_up_path`.


## Require authentication in your controllers

In `application_controller` (for all controllers) or in some controller just add:

```ruby
before_filter :authenticate_user!
```

## Fetching user information

All info about any particular user ca be obtained using auth api (`/users/uid.json` path).


## Read the source, there are few features not mentioned in this README


# Inter-Application Communication

You need to have "App Authorization" created by Exvo first.

Contact us and provide following details:

* `consumer_id` - Id of an app that will be a consumer (this is you)
* `provider_id` - Id of the provider app
* `scope`       - The tag associated with the api you want to use in the provider app


## Consumer side

```ruby
consumer = ExvoAuth::Autonomous::Consumer.new(
  :app_id => "this is client_id of the app you want to connect to"
)
consumer.get(*args) # interface is exactly the same like in HTTParty. All http methods are available (post, put, delete, head, options).
```


## Provider side

See `#authenticate_app_in_scope!(scope)` method in `ExvoAuth::Controllers::Rails` (or Merb). This method lets you create a before filter.
Scopes are used by providing app to check if a given consuming app should have access to a given resource inside a scope.
If scopes are empty, then provider app should not present any resources to consumer.


## Example of the before filter for provider controller:

```ruby
before_filter {|c| c.authenticate_app_in_scope!("payments") }
```

In provider controller, which is just a fancy name for API controller, you can use `#current_app_id` method to get the app_id of the app connecting.


# Dejavu - replay non-GET requests after authentication redirects

## Limitations:

* doesn't work with file uploads
* all request params become query params when replayed
