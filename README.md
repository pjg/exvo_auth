# exvo_auth

This gem supplements the [omniauth-exvo](https://github.com/Exvo/omniauth-exvo/)a gem. Together they implement the oauth2 protocol for handling users and applications authentication at Exvo.

This gem depends on the [exvo_helpers](https://github.com/Exvo/exvo_helpers) gem for all of its configuration.



## Requirements

* Runs on Ruby 1.8.7 & 1.9.2 (preferred version)
* Rails 3.0+ (works with Rails 3.1) or Merb



## Installation

Add it to Gemfile:

```ruby
gem "exvo_auth"
```

Run bundle:

```bash
$ bundle
```

The preferred way to configure this gem is via the ENV variables:

```ruby
ENV['AUTH_CLIENT_ID']     = "foo"
ENV['AUTH_CLIENT_SECRET'] = "bar"
ENV['AUTH_DEBUG']         = "true"          # [OPTIONAL] dumps all HTTP traffic to STDERR, useful during development; it *has to be a string, not a boolean*
ENV['AUTH_REQUIRE_SSL']   = "false"         # [OPTIONAL] disable SSL, useful in development (note that all apps API urls must be http, not https); it *has to be a string, not a boolean*
ENV['AUTH_HOST']          = "test.exvo.com" # [OPTIONAL] override the default auth host
```

But you can also set things directly in the `config/application.rb` file (before the middleware declaration):

```ruby
Exvo::Helpers.auth_client_id     = "foo"
Exvo::Helpers.auth_client_secret = "bar"
Exvo::Helpers.auth_debug         = true            # boolean
Exvo::Helpers.auth_require_ssl   = false           # boolean
Exvo::Helpers.auth_host          = "test.exvo.com"
```

Add this line to `config/application.rb`:

```ruby
config.middleware.use ExvoAuth::Middleware
```

Add routes (Rails example):

```ruby
match "/auth/exvo/callback" => "sessions#create"
match "/auth/failure"       => "sessions#failure"
match "/sign_out"           => "sessions#destroy"
```

Include controller helpers into your application controller

```ruby
include ExvoAuth::Controllers::Rails # (or Merb)
```

Implement a sessions controller (Rails example):

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

It's good to have your SessionsController#create action a little more extended, so that each time the user logs in into the app, his user data (like email, nickname, etc.) is updated from auth (his profile):

```ruby
def create
  auth = request.env["omniauth.auth"]
  user = User.find_or_create_by_uid(auth["uid"])

  if user && user.update_attributes(:nickname => auth["info"]["nickname"], :email => auth["info"]["email"], :plan => auth["extra"]["user_hash"]["plan"], :language => auth["extra"]["user_hash"]["language"])
    sign_in_and_redirect!
  else
    fail "Could not update user"
  end
end
```

This is what you get (and what you can use/save for the local user) from auth (example data as of 2012-01):

```ruby
request.env["omniauth.auth"].inspect

  { "provider" => "exvo",
    "uid" => 1,
    "credentials" => {
      "token" => "a2d09701559b9f26a8284d6f94670477d882ad6d9f3d92ce9917262a6b54085fa3fb99e111340459"
    },
    "info" => {
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


Implement `#find_or_create_user_by_uid(uid)` in your Application Controller

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
sign in path:                       "/auth/exvo"
sign up path:                       "/auth/exvo?x_sign_up=true" # this is OAuth2 custom param
sign in path with a return address: "/auth/exvo?state=url"      # using OAuth2 state param
```

You have a handy methods available in controllers (and views in Rails): `sign_in_path` and `sign_up_path`.


## Require authentication in your controllers

In `application_controller` (for all controllers) or in some controller just add:

```ruby
before_filter :authenticate_user!
```

## Fetching user information

All info about any particular user can be obtained using auth api (`/users/uid.json` path).



## Inter-Application Communication

You need to have "App Authorization" created by Exvo first.

Contact us and provide following details:

* `consumer_id` - Id of an app that will be a consumer (this is you)
* `provider_id` - Id of the provider app
* `scope`       - The tag associated with the api you want to use in the provider app


### Consumer side

```ruby
consumer = ExvoAuth::Autonomous::Consumer.new(
  :app_id => "this is client_id of the app you want to connect to"
)
consumer.get(*args) # interface is exactly the same like in HTTParty. All http methods are available (post, put, delete, head, options).
```


### Provider side

See `#authenticate_app_in_scope!(scope)` method in `ExvoAuth::Controllers::Rails` (or Merb). This method lets you create a before filter.
Scopes are used by providing app to check if a given consuming app should have access to a given resource inside a scope.
If scopes are empty, then provider app should not present any resources to consumer.


Example of the before filter for provider controller:

```ruby
before_filter { |c| c.authenticate_app_in_scope!("payments") }
```

In the provider controller, which is just a fancy name for API controller, you can use `#current_app_id` method to get the `app_id` of the app connecting.


## Dejavu

Replay non-GET requests after authentication redirects.

Limitations:

* doesn't work with file uploads
* all request params become query params when replayed



Copyright © 2011-2012 Exvo.com Development BV, released under the MIT license
