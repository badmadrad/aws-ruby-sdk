#!/usr/bin/env ruby
require 'rubygems'
require 'aws-sdk'
require 'pp'

sns = AWS::SNS.new
# Create New Topic
puts "What is the topic name?"
STDOUT.flush
topic1 = gets.chomp
sleep 0.5
puts "Creating Topic..."

list1 = sns.topics.create("#{topic1}")
sleep 1.0
puts "Getting the ARN of the topic..."
arn1= list1.arn
puts "ARN for #{topic1} = #{arn1}"


#Get desired name for queue
puts "What is the name of the queue you want to create?"
STDOUT.flush
queue = gets.chomp
sleep 0.5

sqs = AWS::SQS.new
# Create Queue
puts "Creating Queue #{queue}..."
q = sqs.queues.create("#{queue}")
sleep 0.5

if q.exists? == true
	puts "The #{queue} queue has been created"
sleep 0.5

#Subscribe SQS Queue to SNS Topic
qarn = q.arn
puts "Queue arn = #{qarn} "
sleep 1.0
puts "Subscribing queue to topic"
list1.subscribe(q)
sleep 1.0

# Now publishing one message
puts "Now publishing a message of TEST with the subject HARVEY"
puts "Item should be a visible message in queue"
list1.publish("TEST", :subject => "HARVEY")
sleep 1.0

#Check queue for message
visib = q.visible_messages
invisib = q.invisible_messages

puts "There are currently #{visib} visible messages and #{invisib} invisible messages in the #{queue} queue."
sleep 2.0
	if "#{visib}" != 0
	then 
	puts "Message successfully sent! Will now delete everything."
	sleep 1.0
	puts "Now deleting #{queue} queue..."
	q.delete
	sleep 1.0
	puts "Now deleting #{topic1} topic..."
	list1.delete
	sleep 1.0
	puts "Goodbye!"
	exit
	else
	puts "Hmm...something ain't working right...try from AWS Console. Exiting...."
	end
	exit
else
	puts "Queue creation has failed for #{queue}. Exiting..."
end
exit
