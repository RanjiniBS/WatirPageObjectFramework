require 'watir-webdriver'
require 'page-object'
require 'page-object/page_factory'
require 'log4r'
require 'log4r/outputter/datefileoutputter'

World PageObject::PageFactory

CONFIGFILE = YAML.load_file('configoptions.yml')

driver = (ENV['WEB_DRIVER'] || :firefox).to_sym
client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180

browser = Watir::Browser.new driver, :http_client => client

Before { @browser = browser }

browser.window.maximize

FAILED_SCENARIOS_SCREENSHOTS_DIR = "failed_scenarios_screenshots"

After do |scenario|
  screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
  if scenario.failed?
    Dir::mkdir("#{FAILED_SCENARIOS_SCREENSHOTS_DIR}") if not File.directory?("#{FAILED_SCENARIOS_SCREENSHOTS_DIR}")
    screenshot = "./#{FAILED_SCENARIOS_SCREENSHOTS_DIR}/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}_#{Time.now.strftime("%H_%M_%S__%d_%m_%Y")}.png"
    @browser.driver.save_screenshot(screenshot)
    embed screenshot, 'image/png'
  end
end

include Log4r

LOG4R_LOGS_DIR = "logs"
LOG4R_LOGGER_NAME = "sample_tests"
LOG4R_LOGS_FILE = "#{LOG4R_LOGGER_NAME}.log"

# create a logger
$log = Log4r::Logger.new("#{LOG4R_LOGGER_NAME}")

# to log about the info where log method was called
$log.trace = true

# type of log statements to log in log file
#$log.level = ERROR

# format the log4r message pattern
fmtr = PatternFormatter.new(:pattern => "%d [%l] %m \n \t\t [%t]")
#Create a directory 'logs' for sample test log
Dir::mkdir("#{LOG4R_LOGS_DIR}") if not File.directory?("#{LOG4R_LOGS_DIR}")

# define log4r outputters
Log4r::StdoutOutputter.new('console', :formatter => fmtr)
Log4r::FileOutputter.new('logfile',
                         :filename=>"#{LOG4R_LOGS_DIR}/#{LOG4R_LOGS_FILE}",
                         :trunc=>false,
                         :formatter => fmtr)

$log.add('console','logfile')

puts "ENV => #{ENV.inspect}"

if ENV['HEADLESS'] == 'true'
  require 'headless'

  headless = Headless.new
  headless.start

  at_exit do
    headless.destroy
  end
else
  at_exit do
    browser.close
  end
end

#--------------------------------> Start Order of Execution Code <-----------------------------------#
# Overrides the method +method_name+ in +obj+ with the passed block
def override_method(obj, method_name, &block)
  # Get the singleton class/eigenclass for 'obj'
  klass = class <<obj; self; end

  # Undefine the old method (using 'send' since 'undef_method' is protected)
  klass.send(:undef_method, method_name)

  # Create the new method
  klass.send(:define_method, method_name, block)
end

def get_weight(x)
  weights = YAML::load(File.open('features/support/data/order.yml')) #this is expensive but is done only on rake start
  weight = weights[x]
  if weight == nil or weight == ''
    weight = '1000' #this is because we want to run the newly added tests first.
  end
  return weight.to_i()
end

def sort_according_to_weights(features)
  return features.sort { |x,y|  get_weight(y)  <=> get_weight(x)}
end

AfterConfiguration do |configuration|
  #puts "\n\n\n *****  config: #{configuration} "
  featurefiles =  configuration.feature_files

  override_method(configuration, :feature_files) {
    #puts "overriding the old featurefiles according to their weight"
    sorted_files = sort_according_to_weights(featurefiles);
    sorted_files
  }

  #puts "\n\n *************************** features will be executed in following order: \n"
  for i in configuration.feature_files
    #puts "#{i} : weight: #{get_weight(i)}"
  end
end

puts "\n\nResetting features execution sequence to \"order.yml\"... Done!\n\n"


#--------------------------------> End Order of Execution Code <-----------------------------------#
