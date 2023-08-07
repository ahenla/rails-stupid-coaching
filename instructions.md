Stupid Coaching
Report an issue View on GitHub
Setup
You should already have rails installed. Check it with:

rails -v

# You should see your rails version here

If not, go back to the dedicated section of the macOS, Windows or Ubuntu setup.

Background & Objectives
Remember your first weeks of Ruby? We only had the terminal for the program user interface. Those days are over, we will now use Rails! This means:

The program user interface is now your browser
The only way to communicate with your Rails app is through HTTP requests
There is no rake here. Also, do not create your Rails app in fullstack-challenges.

cd ~/code/ahenla
rails new rails-stupid-coaching --skip-active-storage --skip-action-mailbox
cd rails-stupid-coaching
git add .
git commit -m "rails new"
gh repo create --public --source=.
git push origin master
We add the flag --skip-active-storage & --skip-action-mailbox to skip the installation of Active Storage & Action Mailbox which are two parts of Rails we don’t need for now.

Objective: We will implement a simple Rails application with 2 pages:

First page is a form with an input, where a user can type a question to ask the Coach
After submitting the form, the user is redirected to another page where she/he will see her/his question and the coach answer.
That’s it!

Specs
Get familiar with Rails command line basics. For this exercise, you should know at least how to:

Create a new Rails app
Launch a web server to open your app locally
Generate a new controller from the command line
Check your routes with the relevant rails command
Launch a rails server
Every web developer starts working by launching a server and opening a browser to test live the features they code. Go ahead:

launch a server in your terminal
open localhost:3000 in your favourite web browser! You should see Rails’ welcome page.
Every time you write some code in a file, save it and refresh your browser. You will get many error messages, but it is important to get familiar with them. This way, you will understand Rails’ execution flow and learn how to fix them!

Generate controller
First things first, let’s generate a QuestionsController we’ll use for our two pages. Remember the rails command to do that?

Display the form: /ask
We want to display a page with a <form> to our users at localhost:3000/ask. In Rails, this counts as a user story, so we need more than an HTML file to make it happen. For every user action in Rails, we need to code (i) a route, (ii) an action, and (iii) a view. Remember the MVC pattern?

Route

Write a simple route to serve the GET /ask HTTP request to the ask action of the questions controller. As a reminder, here is the pattern of a route coded in Rails:

verb "url", to: "controller#action"
Controller

After setting up the route, it’s time to code the action. Go ahead and add an ask action in your QuestionsController! Do we need to define an instance variable here? We’ll figure it out while coding the view!

Oh and by the way, do you remember how to display all your routes in the terminal?

View solution
View

Last step to display the form, let’s create a view! Do you remember in which folder it should be and how it should be named? That’s one of Rails’ conventions, the Action View convention. Refresh the page at localhost:3000/ask, if you named your file properly you should finally see a page without an error! For now it’s empty, let’s finally add the <form>. Remember the syntax?

<form action="???" data-turbo="false">
  <input type="text" name="???">
  <input type="submit" value="Ask!">
</form>
The native behaviour of a <form> tag is to generate the HTTP request defined by the method and action attributes.

the method attribute holds the HTTP verb (GET by default)
the action attribute holds the url of the request it triggers on submit
In the <input>, the name attribute enables you to set the key of the corresponding parameter.

Here we want the form to trigger our second user story: answer, which should be routed on /answer. Go ahead and replace the ??? above and try to submit the form.

You should get a routing error, let’s code the answer now!

Display the Coach’s Answer: /answer
Time to implement the logic in the answer action (second step of the user journey). For this second user story, follow the same methodology as in 1. Display the form:

code the route
code the action (in the controller)
code the view
And make sure you refresh your page frequently in your browser to let Rails’ execution flow drive your development!

The answer.html.erb will display the question you ask your coach as well as his answer. The controller will need to read the question from params and compute an instance variable @answer for the view to display. Here are two requests that you should be able to handle:

localhost:3000/answer?question=hello
localhost:3000/answer?question=what time is it?
If you don’t remember about the coach (poor) logic, here it is:

If the message is I am going to work, the coach will answer Great!
If the message has a question mark ? at the end, the coach will answer Silly question, get dressed and go to work!.
Otherwise the coach will answer I don't care, get dressed and go to work!

Backlink from /answer to /ask
Add a link to /ask on the answer.html.erb view using the link_to Rails helper.

Make it look nice!
We have not covered the front-end aspect of a Rails project for now, but you can start designing your app!

Install Bootstrap stylesheets

Following the documentation, install Bootstrap to your Rails app by copy-pasting the link tag in the head of the application.html.erb layout:

<!-- app/views/layouts/application.html.erb -->
<!-- [...] -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
You can now use any Bootstrap class anywhere in your Rails views 🎉

Write custom style

Write your own CSS in the app/assets/stylesheets/application.css file. This file is linked in the head of the application.html.erb layout with the stylesheet_link_tag.

Go on and make the design match the screenshots 🎨

Testing (Optional)
⚠️ Please skip this section if you don’t feel at ease yet with Rails internal. You can always come back here later in the day after completing the Longest Word Game exercise.

First, delete the test/controllers/questions_controller_test.rb file if it got generated. We will be doing System Testing. The goal of this kind of testing is to automate all the manual testing of “code editing / go to the browser / reload the page / check if this is working”. Everything you did manually in the browser can be done via code!

We will use Headless Chrome for System Testing. It’s a browser without a user interface, well-suited for this kind of automated tests. Before running your system tests you need to make sure you have a recent version of Chrome on your system (not Chromium). It’s available for both macOS and Ubuntu.

After the installation you can open the following file and replace all its content with:

# test/test_helper.rb

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
fixtures :all
end

Capybara.register_driver :headless_chrome do |app|
options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu window-size=1400,900])
Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.save_path = Rails.root.join('tmp/capybara')
Capybara.javascript_driver = :headless_chrome
Then in the following file update this line:

# test/application_system_test_case.rb

require "test_helper"
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
driven_by :headless_chrome # Update this line
end
Ready? Let’s dive into Rails Testing.

In the terminal, run the following to create the test file:

rails g system_test questions
Open the generated file in your text editor, and write your first test:

# test/system/questions_test.rb

require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
test "visiting /ask renders the form" do
visit ask_url
assert_selector "p", text: "Ask your coach anything"
end
end
Run the test in the terminal with:

rails test:system
⚠️ If you are getting a Webdrivers::BrowserNotFound: Failed to find Chrome binary error, you need to install the latest version of Chrome:

# macOS

brew install --cask google-chrome

# Ubuntu

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm -rf google-chrome-stable_current_amd64.deb
Once you have installed it, you can relaunch the tests with rails test:system.

Now that they are running, if you look closely at the test scenario, you can read it as:

Go to the /ask page
Make sure the page got rendered and we can read Ask your coach anything.
Great! That’s our first feature test. What do we want to test next? If you think about what you manually did, it was typing some text (with different scenarios) and then clicking the button “Ask”. Let’s do that with tests!

# test/system/questions_test.rb

require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase

# [...]

test "saying Hello yields a grumpy response from the coach" do
visit ask_url
fill_in "question", with: "Hello"
click_on "Ask"

    assert_text "I don't care, get dressed and go to work!"

end
end
Intrigued about this syntax? This is the capybara gem! Very helpful in this testing context where we need to automate clicking on links, buttons, or filling forms. Have a look at its DSL.

Now your turn ✌️. Try to implement other scenarios in your system tests.

Screenshots

The equivalent of binding.pry in the test world is to take screenshots. Let’s add the launchy gem to the Gemfile (in the :test group):

# Gemfile

group :test do

# [...]

gem "launchy"
end
And run bundle install. In your code you just have to write the following:

take_screenshot
It will take screenshots in the Headless Chrome. They will go in the tmp/screenshots folder.
