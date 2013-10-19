#!/usr/bin/env ruby
require 'rubygems'
require 'aws-sdk'
require 'pp'


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
pp sqs.queues.map(&:url)
sleep 0.5

#Get current visibility timeout
current = q.visibility_timeout
puts "Current visibility timeout is #{current} seconds"
sleep 0.5

# Setting Visibility Timeout
puts "How many seconds for the visibility timeout?"
STDOUT.flush
timeout = gets.chomp
sleep 0.5
puts "Changing visibility timeout..."
vchange = q.visibility_timeout=("#{timeout}")
sleep 0.5
puts "Verifying visibility timeout..."
sleep 0.5
verify = q.visibility_timeout
puts "Current visibility timeout is #{verify} seconds"
sleep 0.5

# Initial Amount of Messages in Queue
initial = q.visible_messages
puts "You have #{initial} messages in #{queue} queue"
sleep 0.5

# Insert, retrieve, and delete first message
puts "Sending message HELLO to #{queue} queue"
msg1 = q.send_message("HELLO")
puts "Sent message: #{msg1.id}"
sleep 0.5

puts "Receiving sent message..."
rec1 = q.receive_message( )

puts "Message received: #{rec1.body}"
sleep 0.5
puts "Deleting message #{rec1.body} from queue..."
rec1.delete
sleep 0.5
initial2 = q.visible_messages
puts "Verifying you have no messages in queue..."
sleep 0.5
puts "You have #{initial2} messages in #{queue} queue"
sleep 1

#Insert second message
puts "Sending message MESSAGE2 to #{queue} queue"
msg2 = q.send_message("MESSAGE2")
puts "Sent message: #{msg2.id}"
sleep 0.5
puts "Receiving sent message..."
rec2 = q.receive_message( :body => "MESSAGE2")
puts "Message received: #{rec2.body}"
sleep 0.5
puts "Waiting 30 seconds..."
 sleep 30
puts "Ok. I'm back! Showing all messages in #{queue} queue..."
sleep 0.5

visib = q.visible_messages
invisib = q.invisible_messages

puts "There are currently #{visib} visible messages and #{invisib} invisible messages in the #{queue} queue."
sleep 0.5

#Insert add two more messages
puts "Now sending two more messages to #{queue} queue"
sleep 0.5
puts "Sending message MESSAGE3 to #{queue} queue"
sleep 0.5
msg3 = q.send_message("MESSAGE3")
puts "Sent message: #{msg3.id}"
sleep 1
# Send 4th Message
puts "Sending message MESSAGE4 to #{queue} queue"
msg4 = q.send_message("MESSAGE4")
sleep 0.5
puts "Sent message: #{msg4.id}"
sleep 0.5
puts "Waiting 30 seconds..."
sleep 30

visib2 = q.visible_messages
invisib2 = q.invisible_messages
pp sqs.queues.map(&:url)
puts "There are currently #{visib2} visible messages and #{invisib2} invisible messages in the #{queue} queue."
sleep 1.0
puts "Now deleting #{queue} queue..."
q.delete
sleep 1.0
	if q.exists? == false
        puts "The #{queue} queue has been deleted. Goodbye!"
	exit
	else
	puts "The #{queue} still exists for some reason. Try to delete through AWS Console. Exiting..."
	end
	exit


else
	puts "Queue creation has failed for #{queue}. Exiting..."
end
