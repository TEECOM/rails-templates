def add_gems
  gem "high_voltage", "~> 3.1"

  gem_group :development, :test do
    gem "factory_bot_rails"
    gem "faker"
    gem "rspec-rails"
    gem "standard"
  end

  gem_group :test do
    gem "shoulda-matchers"
  end
end

def configure_generators
  inject_into_class "config/application.rb", "Application", <<-RUBY

      config.generators do |generate|
        generate.helper false
        generate.javascripts false
        generate.request_specs false
        generate.routing_specs false
        generate.stylesheets false
        generate.test_framework :rspec
        generate.view_specs false
      end

  RUBY
end

def add_rspec
  run "rm -rf test"

  generate "rspec:install"

  append_to_file "spec/rails_helper.rb", <<~CONFIG

    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        with.test_framework :rspec
        with.library :rails
      end
    end
  CONFIG

  insert_into_file(
    "spec/rails_helper.rb",
    "\n\nDir[Rails.root.join(\"spec\", \"support\", \"*.rb\")].sort.each { |f| require f }",
    after: "# Add additional requires below this line. Rails is not loaded until this point!"
  )

  create_file "spec/support/factory_bot.rb", <<~CONFIG
    RSpec.configure do |config|
      config.include FactoryBot::Syntax::Methods
    end
  CONFIG
end

def add_home_page
  create_file "config/initializers/high_voltage.rb", <<~CONFIG
    HighVoltage.configure do |config|
      config.home_page = "home"
    end
  CONFIG

  create_file "app/views/pages/home.html.erb", <<~PAGE
    <h1 class="mt-10 text-2xl text-center font-bold">
      Welcome!
    </h1>
  PAGE
end

def add_tailwind
  run "yarn add tailwindcss --dev"

  create_file "tailwind.config.js", <<~CONFIG
    const defaultTheme = require('tailwindcss/defaultTheme')

    module.exports = {
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter', ...defaultTheme.fontFamily.sans]
          }
        }
      },
      variants: {},
      plugins: []
    }
  CONFIG

  create_file "app/javascript/css/application.css", <<~STYLES
    @import url("https://rsms.me/inter/inter.css");

    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";
  STYLES

  append_to_file "app/javascript/packs/application.js", "require(\"css/application.css\")"

  insert_into_file(
    "postcss.config.js",
    "\n    require('tailwindcss'),",
    after: "require('postcss-import'),"
  )

  insert_into_file(
    "app/views/layouts/application.html.erb", 
    "\n    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>",
    after: "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
  )
end

add_gems

after_bundle do
  configure_generators

  add_rspec
  add_home_page
  add_tailwind

  rails_command "db:create"
  rails_command "db:migrate"

  run "bundle exec standardrb --fix"

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  say
  say "App successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  - cd #{app_name}"
  say "  - bin/rails s"
end
