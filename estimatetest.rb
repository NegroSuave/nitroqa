require "selenium-webdriver"
require 'logger'
require "watir"
filename = DateTime.now.strftime("%d%b%Y%H%M%S")
$log = Logger.new ("#{filename}estimate-test.log")


#Environments
#Demo 1-19
#DevTB 1-4
#QA


print "What environment is this going to be run in? (DevTB, Demo, QA):"
env_name = gets.chomp

print "Which server number? (Put 0 if QA)"
env_number = gets.chomp

if "#{env_name}" == 'DevTB' then env_add = "nitrodevtb#{env_number}.mydatainmotion.com"
elsif "#{env_name}" == 'Demo' then env_add = "nitrodemo#{env_number}.mydatainmotion.com"
elsif "#{env_name}" == 'QA' then env_add ="nitroqa.mydatainmotion.com"
else p "Invalid Environment Name"
end

puts "https://#{env_add}"
#p "What environment is this test script going to be run in?: "
#env_add = gets.chomp

print "Nitro User name?: "
user_name = gets.chomp

print "Nitro Password?: "
password = gets.chomp
$log.info p "User name: #{user_name}"

browser = Watir::Browser.new :chrome

#Navigate to environment and login
browser.goto "https://#{env_add}"
$log.info ("Confirm Nitro URL")
$log.info p browser.url
browser.text_field(:id => "email").set "#{user_name}"
browser.text_field(:id => "password").set "#{password}"
browser.element(:name => "button").click
$log.info ("Confirm successful login")
$log.info p browser.title

if browser.element(:link_text => 'Acknowledge').exists?
  then browser.element(:link_text => "Acknowledge").click
else p "No Time Sheet Verification"
end


#Ensure we are on the proper starting page
browser.goto "https://#{env_add}/estimates"
$log.info ("Confirm URL location")
$log.info p browser.url

#browser.goto "https://nitroqa.mydatainmotion.com/estimates/4886504/edit"


#Click on Create Test Estimate
browser.element(:link_text => "Create a Test Estimate").wait_until_present
browser.element(:link_text => "Create a Test Estimate").click

#IF verify screen present clear through it
sleep 5
if browser.element(:link_text => 'Verify').exists?
  then browser.element(:link_text => "Verify").click
  browser.element(:id => "home-submit").wait_until_present
  browser.element(:id => "home-submit").click
else p "No Verify Button"
end

#Verify page is ready
browser.element(:id => 'add_new_product').wait_until_present
$log.info ("Confirm URL location")
$log.info p browser.url

#Create roofing estimate
browser.element(:id => "add_new_product").click
browser.text_field(:id => "item_location").wait_until_present
browser.text_field(:id => "item_location").set "Whole House"
sleep 1
browser.text_field(:id => "item_quantity").set "2"
sleep 1
browser.text_field(:id => "item_width").set "2500"
sleep 1
browser.text_field(:id => "item_height").set "1"
sleep 1
browser.element(:link_text => "Roofing").click
sleep 1
browser.link(text: 'None').wait_until_present
browser.link(text: 'None').click
sleep 1
browser.element(:link_text => "GAF").wait_until_present
browser.element(:link_text => "GAF").click
sleep 1
#Using Architectural Shingles here as QA environment hasn't been refreshed this section will need to be redone for Fortitude 20161020-GT
#browser.element(:link_text => "Architectural Shingles").wait_until_present
#browser.element(:link_text => "Architectural Shingles").click
#browser.element(:link_text => "Barkwood").wait_until_present
#browser.element(:link_text => "Barkwood").click
#browser.element(:link_text => "Standard Shingle").wait_until_present
#browser.element(:link_text => "Standard Shingle").click
browser.element(:link_text => "Fortitude").wait_until_present
browser.element(:link_text => "Fortitude").click
sleep 1
browser.element(:link_text => "Standard Shingle").wait_until_present
browser.element(:link_text => "Standard Shingle").click
sleep 1
browser.element(:link_text =>"Cobblestone").wait_until_present
browser.element(:link_text =>"Cobblestone").click
sleep 5

#browser.send_keys :enter
#browser.send_keys :enter
#browser.send_keys :enter

browser.element(:id => "build-form-submit").wait_until_present
browser.element(:id => "build-form-submit").click
#browser.send_keys :enter

#Confirm estimate page
sleep 5
$log.info p "Initial Estimate URL"
$log.info p browser.url
browser.screenshot.save ("/Users/ #{filename}.jpg")
$log.info p "Screenshot Saved of Estimate under '/Users/ #{filename}.jpg'"

browser.element(:class => "dropdown-toggle", :index =>4).click
sleep 1
browser.element(:link_text  => 'Prepare Estimate').click
sleep 1
browser.element(:link_text => 'Next').click
sleep 1
browser.element(:link_text => 'Accept').click
sleep 1
browser.send_keys :enter
sleep 1

browser.checkbox(:id => 'project_pay_cash').set
sleep 1
browser.text_field(:id => 'project_payments_attributes_0_check_number').set "1738"
browser.text_field(:id => 'project_payments_attributes_0_amount').set "18595.79"
browser.checkbox(:id => 'project_owner_signature_1').set

browser.send_keys :enter
sleep 1
browser.element(:class => 'btn', :class => 'btn-default', :index =>4).click
sleep 1
browser.element(:class => 'btn', :class => 'btn-default', :index =>10).click
sleep 1
browser.element(:class => 'btn', :class => 'btn-default', :index =>18).click

sleep 30
#browser.element(:class => 'btn', :class => 'btn-default', :index =>19).click
browser.element(:class => 'btn', :class => 'btn-primary', :class => 'btn-lg').click
#browser.send_keys :enter
sleep 2
browser.element(:class => 'btn', :class => 'btn-default', :index =>4).click
sleep 30
$log.info p "Ending Estimate URL page"
$log.info p browser.url
$log.info p "Nitro Estimate Testing Complete, BITCH!"

#browser.file_field(id: "project_document_doc").set(file.expand_path("../Users/#{filename}.jpg"))
#browser.element(:link_text => "Upload Document").click
#sleep 1

#https://nitroqa.mydatainmotion.com/estimates/4886450/edit
#https://nitroqa.mydatainmotion.com/projects/494873/project_documents
#"https://nitroqa.mydatainmotion.com/estimates/4886534/edit"
#titusfortner
#5:24 PM Yeah, this should work:

#element = browser.file_field(id: "project_document_doc").set("/path/to/file")
#browser.file_field(id: "project_document_doc").set("/path/to/file")

#browser.file_field(id: "project_document_doc").set("../Images/26Oct2016172009.png")
