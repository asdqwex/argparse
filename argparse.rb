#!/usr/bin/env ruby
#
# Useage: ./argparse --whiches argument1 -doer="we" match
# Useage: ./argparse --whiches argument2 -doer="them" unmatch
#
############################################################

command = ARGV.to_s

class Argparser
	def parse(command)
		command_object = {}
		command_parts = command.split
		command_parts.each_with_index do |part, index|
			if part.include?('-') && part.include?('=')
				sub_parts = part.split('=')
				command_key = sub_parts[0].delete('-"][,')
				command_value = sub_parts[1].delete('-"][,')
				command_object[command_key]	= command_value
			elsif part.include?('-')
				command_key = part.delete('-"[,')
				command_value = command_parts.slice!(index+=1).delete('-"][,')
				command_object[command_key]	= command_value
			else
				command_object[part.delete('-"][,')] = {}
			end
		end
		return command_object
	end
end

class Program
	def initialize(pasable_command_object)
		pasable_command_object.each do |command_name, command_data|
			if Program.method_defined? command_name
				self.method(command_name).call(command_data)
			else
				puts 'invalid command'
			end
		end
	end

	@@arguments = {}
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
		puts 'match was run expecting argument1 => we'
		puts 'got ', @@arguments
	end

	def unmatch(argument_object)
		puts 'unmatch was run expecting argument2 => them'
		puts 'got ', @@arguments
	end
end 

parser = Argparser.new

pasable_command_object = parser.parse(command)

puts pasable_command_object

run_program = Program.new(pasable_command_object)
