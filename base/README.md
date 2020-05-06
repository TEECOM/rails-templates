# Base Rails Template

This template aims to provide a minimal level of configuration that can be used
for almost any Rails project. It does not make any assumptions about
authentication methods or database tables.

Here's what it focuses on...

#### Testing

To help with testing, this template will include and set up:

- [`RSpec`](http://rspec.info) as the testing mechanism
- [`Factory Bot`](https://github.com/thoughtbot/factory_bot) for test factories
- [`Faker`](https://github.com/faker-ruby/faker) for auto-generated fake testing data
- [`Shoulda Matchers`](https://matchers.shoulda.io) for less boilerplate-filled model tests

#### Styling

To kickstart well-styled application development, this template will set up
[Tailwind CSS](https://tailwindcss.com). It will also initialize a near-empty
home page for you to get started using
[`High Voltage`](http://thoughtbot.github.io/high_voltage/).

#### Miscellaneous Configuration

This template doesn't do to much in terms of application configuration, but it
does a few things to help you get started:

- Disables annoying, seldom-used auto generators (helpers, stylesheets, view
  specs, etc.)
- Runs [`standard`](https://github.com/testdouble/standard) on the codebase
- Creates and initializes your database
- Creates an "Initial Commit"

## Usage

To use this template to initialize a new app, run:

```
$ rails new -d postgresql -m https://raw.githubusercontent.com/TEECOM/rails-templates/production/base/template.rb {{app name}}
```

## Quick Walkthrough

It can sometimes be helpful to make a quick example app to explore how a
template configures the initial Rails application. Start by making a new example
app:

```
$ rails new -d postgresql -m https://raw.githubusercontent.com/TEECOM/rails-templates/production/base/template.rb example
```

### See some failing tests

Let's get some tests failing! Start off by creating a new model:

```
$ bundle exec rails g model User name:string
```

And migrate your database:

```
$ bundle exec rails db:migrate
```

This should have generated a few files for you, but the ones we care about are:

- `spec/models/user_spec.rb`
- `spec/factories/users.rb`

Open `spec/models/user_spec.rb` and replace the line reading

```ruby
pending "add some examples to (or delete) #{__FILE__}"
```

with

```ruby
it { is_expected.to validate_presence_of :name }
```

Now run your tests:

```
$ bundle exec rspec spec
```
```
F

Failures:

  1) User is expected to validate that :name cannot be empty/falsy
     Failure/Error: it { is_expected.to validate_presence_of :name }

       Expected User to validate that :name cannot be empty/falsy, but this
       could not be proved.
         After setting :name to ‹""›, the matcher expected the User to be
         invalid, but it was valid instead.
     # ./spec/models/user_spec.rb:4:in `block (2 levels) in <top (required)>'

Finished in 0.95507 seconds (files took 4.05 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/models/user_spec.rb:4 # User is expected to validate that :name cannot be empty/falsy
```

Success! We failed! Let's add to our list of failures by adding the following
to the user spec:

```ruby
it "continues to fail" do
  user = build(:user)
  expect(user.name).to eq "Not A Real Name"
end
```

Run the tests again and you should now see this error:

```
  2) User continues to fail
     Failure/Error: expect(user.name).to eq "Not A Real Name"

       expected: "Not A Real Name"
            got: "MyString"

       (compared using ==)
     # ./spec/models/user_spec.rb:9:in `block (2 levels) in <top (required)>'
```

`"MyString"`? That's not a very realistic name...

Open up `spec/factories/users.rb` and replace the line containing `"MyString"`
with

```
name { Faker::Name.name }
```

Now when you run the tests, you should see names like:

- Roselia Farrell
- Ashley Franecki
- Andres Halvorson DVM
- Dr. Kira Davis

That's more like it!

### Add some style

Start the rails server by running:

```
$ bundle exec rails s
```

And go to `http://localhost:3000` in your browser. You should see a pretty
bland page that says "Welcome".

Open up `app/views/layouts/application.html.erb` and adjust the opening body
tag to look like this:

```html
<body class="bg-gray-900 text-gray-100">
```

Refresh the page and... Dark mode! I like your style! :sparkles:

Now open `app/views/pages/home.html.erb` and adjust the contents to look like:

```html
<h1 class="mt-10 text-5xl text-center font-black">
  Welcome to my <span class="text-pink-600">example app</span>!
</h1>
```

Refresh the page and see the results!
