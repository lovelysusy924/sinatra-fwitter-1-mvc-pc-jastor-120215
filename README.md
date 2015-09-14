# Sinatra Fwitter 1 MVC

## Objectives

1. Combine everything that we've learned into a complete Sinatra web application.  
2. Understand the difference between class methods and instance methods
3. Understand `self` and how to use it in Ruby
4. Create new instances of of Ruby classes
5. Pass data from our application controller into our view. 
6. Use ERB to combine HTML and Ruby. 


## Overview

We've leanred a ton about Ruby, Sinatra, and MVC so far. Over the next few Units, we'll be combining what we've learned to build our own version of Twitter - Fwitter (short for Flatiron Twitter - get it!? Please don't sue). 

Fork and clone this repository to get started!

## Instructions

To begin, we'll be building out the Sinatra file structure from scratch. While we do, we'll talk about what each file is doing and the different responsibilites of our application. We could, if we wanted to, write our entire application in one file, but it would be very difficult to read and debug. Keeping things organized is called "seperation of concerns" and is an important concept when prgoramming. Let's start building out our file structure. 

### 0). Create your Project Directory

Since you're building this project from scratch (as opposed to forking and cloning some pre-written code), you'll need to set up your root project directory. In your development directory, create a new directory called `fwitter` and `cd` into it.

### 1). Gemfile

What's the first thing we do when running a Sinatra application? If you answered `rackup` or `shotgun`, you're almost right. Before we even start up our server, we run `bundle install`. This command tells the bundler gem to look in the Gemfile of the main directory and install any of the gems listed there from rubygems.org. Remember, gems are just prewritten bundles of code that we can use in our application. Before we can use any of them, such as `sinatra` or `shotgun`, we want to make sure they're installed on our system. 

Create a Gemfile by running `touch Gemfile` from the command line. Inside, add the following code snippets:

```ruby
source "https://rubygems.org"

gem "sinatra"

group :development do
  gem "pry"
  gem "shotgun"
  gem "tux"
end
```

This first line tells bundler to use https://rubygems.org to locate and install gems. Next, bundler will download and install each gem listed, in this case `sinatra`, `pry`, `shotgun` and `tux`. We've added the last three into a group called `development` - this tells bundler only to install them locally on our development machines, not on our production server.

Once the code's been added, go ahead and run `bundle install`. Bundler will install those four gems, plus any gems that they depend on to work properly. 

### 2). environment.rb

After running bundle install, all of the needed gems will be installed on our system, but we haven't actually required them in our application. They're installed, but we're not loading them. By convention, our environment setup is handled by a file called `environment.rb`, located in a directory called `config`, short for configuration.

Make a config directory with `mkdir config` and then create an `environment.rb` file inside of it. For now, all our environment file needs to do is make sure every gem in our Gemfile is required. Bundler provides us with a method to do this. Add the following code to your environment file:

```ruby
require 'bundler'
Bundler.require
```

Line 1 requires the bundler gem. Line two calls a method named `require` on a class called `Bundler` which is defined by the bundler gem. This method goes through our Gemfile and simply requires all of the gems. It's the equiviliant of writing: 

```ruby
require 'bundler'
require 'sinatra'
require 'pry'
require 'shotgun'
# etc...
```
It's way easier to use the Bundler's require method - that way, any gems that we add will be loaded up for us automatically. 

### 3). config.ru

Now that our environment is set up properly, we want to actually start our application. If you answered `rackup` or `shotgun` before, give yourself a pat on the back. When you start your server with the `rackup` or `shotgun` command, our app looks for a file called `config.ru` and executes the code in that file. In the root of this directory, create a file called `config.ru` and add the following code: 

```ruby
require './app/controllers/application_controller'

run ApplicationController
```

Here, we're simply requiring a file called `application_controller` and starting up our ApplicationController class. We haven't actually created this yet, but don't worry - we'll do that shortly.

### 4). app directory

By convention, we store our MVC files - models, views, and controllers, inside of a directory called `app`. Go ahead and make an app directory now, and inside make a directory called `models`, `views`, and `controllers`. 

### 5). public directory

To hold files that will be needed by the frontend, such as css, javascripts, and images, we use a directory called `public`. We can configure Sinatra to use this for such assets automatically so that our filepath links are shorter. 

Make a directory called `public` and inside, create directories for `css`, `js`, and `images`. 

### 5). application_controller.rb

Inside of `app/controllers` create a file called `application_controller.rb` Here, we'll define our routes, actions, and pass data from the models into our views. (In previous labs and lessons, this file has been called `app.rb`)

First, let's require the enviornment.rb file so that all of our gems get imported. 

```ruby
require './config/environment'
```

Next, define a class called `ApplicationController` which inherits from `Sinatra::Base`

```ruby
require './config/environment'

class ApplicationController < Sinatra::Base


end
```

Let's define a basic route and action. 

```ruby
require './config/environment'

class ApplicationController < Sinatra::Base
	
  get '/' do
    'Hello World - I'm building Twitter!'
  end

end
```

Run `shotgun` or `rackup` to preview your work in the browser!

### 6). index.erb

Create an `index.erb` in our views folder. Let's stub out a basic HTML shell. 

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Fwitter</title>
  </head>
  <body>
    
      <h1>Welcome to Fwitter!</h1>
      <p>Any similarities to other social media applications are purely coincidental.</p>

  </body>
</html>
```

Update our controller to render this view. 

```ruby
require './config/environment'

class ApplicationController < Sinatra::Base
	
  get '/' do
    erb :index
  end

end
```
Check out your preview now and you'll get an error: "Cannot Load Such file "app/controllers/views/index.erb". Why? Because by default, Sinatra looks in the same directory as the controller for a directory called views. It's simply trying to find the file in the wrong place. Luckily, we can change Sinatra's default behavior for where the views should be using a configure block. We can also configure out `public` folder here as well. 

```ruby
require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end	
  
  get '/' do
    erb :index
  end

end
```
Now, Sinatra will look for our ERB files in our 'app/views' directory. Refresh the page and see your results!

### 7). tweet.rb

Now that our structure is stubbed out, let's start actually building Twitter! To begin, let's create a model to represent a tweet. Create a new file called `tweet.rb` inside of 'app/models'. Inside of this file, define a class called `Tweet`

```ruby
class Tweet

end
```

Our tweets should be initialized with two attributes for now - a username and a status to represent the content. We use an `initialize` method to ensure that new tweets must have both of these attributes to be instatiated.

```ruby
class Tweet
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
  end
end
```

Our index page will be responsible for displaying all of the tweets that we've created (for now, users will simply see all of the posts rather than having a follower. You have to start somewhere.) Our Tweet class will be responsible for all of the instances of Tweets that get created. We can use a class constant for this.  A class constant is a variable which belongs to the class rather than instances of the class. We define these using ALL_CAPS.

```ruby
class Tweet

  ALL_TWEETS = []
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
  end
end
```

When new tweets are created, they should be added into the `ALL_TWEETS` array. In psuedo-code, this would look as follows:

```ruby
class Tweet

  ALL_TWEETS = []
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
    # here, the tweet that was just created gets pushed into the ALL_TWEETS array
  end
end
```

Being even more specific, we could write this as:

```ruby
class Tweet

  ALL_TWEETS = []
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
    # ALL_TWEETS << the_tweet_that_got_initialized
  end
end
```

This makes sense, but how do we actually access the tweet that got initialized? In Ruby, we can use `self`. `self` refers to the current scope - it's whatever object trigged the current action. Inside of our `initialize` method, `self` refers to the tweet that was just created. 

```ruby
class Tweet

  ALL_TWEETS = []
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
    # ALL_TWEETS << self
  end
end
```

Awesome - now any new tweet that gets created will be held in that array. Currently, though, there's no way to access that class variable outside of the class. Let's make a class method that returns the array. Class methods work just like instance methods, expect we'll call them on our class of `Tweet` instead of instances of tweets. Remember earlier when we used `Bundler.require`? That's a class method. We can define the scope of our methods again by using self. 

```ruby
class Tweet

  ALL_TWEETS = []
  attr_accessor :username, :status
  
  def initialize(username, status)
    @username = username
    @status = status
    # ALL_TWEETS << self
  end
  
  def self.all #self here tells Ruby that this is a class method
    ALL_TWEETS
  end
  
end
```
Now, we'll be able to access that data in our controller!


### 8). Putting It All Together

Now, let's setup our app to display all of the tweets on the index page. First, we need to require our model file in the controller, otherwise we won't have access to the Tweet model we created. Next, let's create an instance variable called `@tweets` and set it equal to our `.all` method.

```ruby
require './config/environment'
require './app/models/tweet'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end	
  
  get '/' do
    @tweets = Tweet.all
    erb :index
  end

end
```

Our `@tweets` variable will be an array of tweets. In our view, let's iterate through that array and display each tweet's username and status. 

```html
<body>
	<h1>Welcome to Fwitter!</h1>
	<p>Any similarities to other social media applications are purely coincidental.</p>
	
	<ul>
		<% @tweets.each do |tweet| %>
			<li><%= tweet.username %> says: <%= tweet.status %></li>
		<% end %>
	</ul>
</body>

```

Awesome! We haven't actually created any tweets yet though - for now, let's hardcode a few in our controller action.

```ruby
require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end	
  
  get '/' do
  	 Tweet.new("taylorswift13", "This is my first Fweet!")
  	 Tweet.new("alberteinstein", "Everything should be made as simple as possible, but not simpler.")
  	 Tweet.new("RealBobDylan", "Don't think twice, it's alright")
    @tweets = Tweet.all
    erb :index
  end

end
```

Awesome - now, our index page will automatically display any new tweets that get created. In the next iteration of Fwitter, we'll add a form so that users can create Tweets dynamically. 


