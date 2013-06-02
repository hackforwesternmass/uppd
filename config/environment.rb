# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Uppd::Application.initialize!

Time::DATE_FORMATS[:date_default] = "%m/%d/%Y"