#!/usr/bin/env ruby
require 'rubygems'
require 'aws-sdk'
require 'pp'

# Get an instance of the SNS interface using the default configuration
sns = AWS::SNS.new

# Create New Topic
puts "What is the topic name?"
STDOUT.flush
topic = gets.chomp
sleep 0.5
puts "Creating Topic..."

list1 = sns.topics.create("#{topic}")
sleep 1.0
puts "Getting the ARN of the topic..."
arn1= list1.arn
puts "ARN for #{topic} = #{arn1}"

# Add Two Emails to Topic

puts "Please enter two emails to subscribe to topic."
sleep 0.5
puts "Email address 1?"
STDOUT.flush
email1 = gets.chomp
sleep 0.5
puts "Email address 2?"
STDOUT.flush
email2 = gets.chomp
sleep 0.5

# Subscribe emails

puts "Adding emails to topic..."
list1.subscribe("#{email1}")
list1.subscribe("#{email2}")
sleep 1.0

# Confirm Emails
puts "You should get confirmation email."
puts "Enter string token from link in email"
puts "Token1?"
STDOUT.flush
token1 = gets.chomp
puts "Token2?"
STDOUT.flush
token2 = gets.chomp
sleep 1.0
puts "Confirming subscriptions..."
conf1 = list1.confirm_subscription("#{token1}")
conf2 = list1.confirm_subscription("#{token2}")

if conf1.confirmation_authenticated? && conf2.confirmation_authenticated? == true
then
puts "Subscription Confirmed!"
sleep 0.5

# Publishing a message
puts "Now lets publish a message!"
puts "Whats the subject of the message?"
subject1 = gets.chomp
puts "Now a message in 5 words or less?"
message1= gets.chomp
sleep 1.0
list1.publish("#{message1}", :subject => "#{subject1}")
puts "Message published. Check your email!"
sleep 30.0
# Delete Topic
puts "Deleting Topic since our job is done here..."
sleep 0.5
list1.delete
	puts "Topic #{topic} Deleted. Goodbye!"
else 
puts "Something is not right....exiting..."	
end
exit

