#!/usr/bin/env ruby
#
# Useage: ./argparse --whiches argument1 -doer="we" match
# Useage: ./argparse --whiches argument2 -doer="them" unmatch
#
############################################################

# Define Argparser class
class Argparser
	# Define parse method
	def parse(command)
		# initialize action_counter
		@@action_counter = 0
		# initialize command_object , will be used to store commands and options
		command_object = {}
		# split the command string into parts on whitespace
		command_parts = command.split
		# for each part of teh commadn string
		command_parts.each_with_index do |part, index|
			# check to see if the command part includes and - or =
			if part.include?('-') && part.include?('=')
				# Split the command part on =
				sub_parts = part.split('=')
				# set command key to the string beofore the = and remove funny characters
				command_key = sub_parts[0].delete('-"][,')
				# set command valur to the string after the = and remove funny characters
				command_value = sub_parts[1].delete('-"][,')
				# add command_key to the command_object with command_value as the value
				command_object[command_key]	= command_value
			# check to see if the command part has a - in it (this might be an edge case; arg=someting-something)
			elsif part.match(/^--/) || part.match(/^-/) 
				command_key = part.delete('-"[,')
				command_value = command_parts.slice!(index+=1)
				command_object[command_key]	= command_value
			else
				command_object[part.delete('-"][,')] = {}
			end
		end
		command_object.each do |key, value|
			if value == {}
				@@action_counter += 1
			end
		end
		puts command_object
		if @@action_counter > 1
			puts 'too many options'
			return
		else
			return command_object
		end
	end
end

class Program

	@@arguments = {}

	def initialize(pasable_command_object)
		if pasable_command_object.nil?
			puts 'no valid command to run'
		else
			pasable_command_object.each do |command_name, command_data|
				if Program.method_defined?(command_name)
					self.method(command_name).call(command_data)
				else
					puts 'invalid command'
				end
			end
		end
	end

	def whiches(key_argument)
		puts 'whiches called with ' + key_argument
		@@key_argument = key_argument
		@@arguments[key_argument] = ''
	end

	def doer(value_argument)
		puts 'doer called with ' + value_argument
		@@arguments[@@key_argument] = value_argument	
	end

	def match(argument_object)
		puts 'match was run, expecting argument1 => we'
		puts 'got ', @@arguments
	end

	def unmatch(argument_object)
		puts 'unmatch was run, expecting argument2 => them'
		puts 'got ', @@arguments
	end
end

command = ARGV.to_s

parser = Argparser.new

run_program = Program.new(parser.parse(command))
