# Brasil

## A [Cuba](cuba.is) JSON API with JWT authentication and authorization

- [Shield](https://github.com/cyx/shield) for initial authentication
- [JWT](https://github.com/jwt/ruby-jwt) (JSON web token) for authenticating API access
- [MongoDB](https://www.mongodb.com/) for persistence
- tested with [Minitest](http://docs.seattlerb.org/minitest/index.html)
- modular design

### setup

get a mongo database up and running

set a $JWT_SECRET in `secrets.rb`, this is protected by `.gitignore`

### routing and structure

From the command line, you run `rackup`, which kicks over the `config.ru` like your mom's old reliable 2003 Camry. You can also use `shotgun` if you have that gem installed for quick server reload while developing.

When a request is made, it enters `app.rb`, gathers its dependencies and finds its middleware:
``` ruby
require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Brasil.use Rack::Session::Cookie, secret: "foo"
Brasil.plugin Brasil::Safe

Brasil.use Shield::Middleware
Brasil.plugin Shield::Helpers
```

Then we hit the routes. But first let's talk about the model `Brasil` first.

Brasil inherits directly from Cuba, and includes some modules. These modules are defined in the `lib/` directory, and are a few small collections of helper methods, which can be shared amongst the controllers, but I thought would be cool to define as shared behavior and then included. These have to do with handling requests, responses, and authentication.

``` ruby
class Brasil < Cuba
  include AuthJwtHelpers
  include RequestHelpers
  include ResponseHelpers
end
```

Great! So we have Brasil ready to handle our routing. Let's take a look at our first route:

```
Brasil.define do
  # no namespace # no auth needed
  on get, root do
    set_response_as_json
    write_res_as_json(root_path: true)
  end
```

We see a `get` matcher, alongside a `root` matcher, and then the actual handling itself, in which we set the response content type to JSON, as well as write a JSON response. This is obviously a sanity check route, returning `{ root_path: true }`, with a few pretty helper methods. Moving on, we finally get to something more interesting. Next, we see:

``` ruby
# auth/ # no auth needed
  on 'auth' do
    run AuthCtrl
  end
```

What does this do? Let's investigate. `AuthCtrl` is found in the `controllers/` directory, and handles authentication for the application. Before moving on, we do notice `run` and quickly remember that that is how this whole thing begins in `config.ru` when we see in that file:

``` ruby
require './app'
run Brasil
```

Spoiler alert, but each time we hit something with `run`, we are actually starting up yet another (Cuba-inherited) instance of Brasil to run some routes, take names, kick ass, and get some stuff done.

Opening this up, we see a similar structure to `app.rb`. We see a few `on` blocks with matchers. The first is for logging in, and the next is for logging out. Let's check out the first one:

``` ruby
on post, 'login' do
  ...
end
```

The implication here is that we only got to this handler by way of `app.rb` handling a request having a route which matches 'auth', regardless of the HTTP method involved. So, taking a step back this is a manual way of namespacing the routes within `app.rb`; anything that we want to handle having to do with authentication is game for going into `AuthCtrl`. You get it? Cool.

Very quickly, this is where the `Shield` gem comes into play - we match the login params to an existing user using Shield's `#login` function, like this:

``` ruby
if login(User, body['login'], body['password'])
  #... write response, and dole out a JWT token
else
  #... horrible bad stuff
end
```

This code is hopefully crytal clear, and as a small plain ol' Ruby library handling authentication (and helping out with authorization elsewhere), Shield is pretty great. So now, we've authenticated a user and given out the JWT token for use as a request header for subsequent requests.












