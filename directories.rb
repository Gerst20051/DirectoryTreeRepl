#!/usr/bin/env ruby

CREATE_COMMAND = 'CREATE'.freeze
DELETE_COMMAND = 'DELETE'.freeze
LIST_COMMAND = 'LIST'.freeze
MOVE_COMMAND = 'MOVE'.freeze
VALID_COMMANDS = [CREATE_COMMAND, DELETE_COMMAND, LIST_COMMAND, MOVE_COMMAND].freeze
EXIT_COMMAND = 'EXIT'.freeze
TEST_MODE = ENV['RACK_ENV'] == 'test'

class DirectoryTreeRepl
  def initialize
    @directories = []
    @should_output_commands = false
  end

  def run
    check_stdin
    repl_loop
  end

  private

  def run_command(command, *args)
    case command
      when CREATE_COMMAND then create_directory(*args)
      when DELETE_COMMAND then delete_directory(*args)
      when LIST_COMMAND then list_directories
      when MOVE_COMMAND then move_directory(args[0], args[1])
      else puts "Invalid Command '#{command}' Skipped"
    end
  end

  def create_directory(directory)
    puts "#{CREATE_COMMAND} #{directory}" if TEST_MODE || @should_output_commands

    if @directories.include? directory
      puts "Directory #{directory} already exists"
    else
      directory_depth = directory.count('/')
      parent_directory = directory.split('/').tap(&:pop).join('/')

      if directory_depth.zero? || @directories.include?(parent_directory)
        @directories.push(directory)
        @directories.sort!
      else
        puts "Cannot create #{directory} - #{parent_directory} does not exist"
      end
    end
  end

  def delete_directory(directory)
    puts "#{DELETE_COMMAND} #{directory}" if TEST_MODE || @should_output_commands

    if @directories.include? directory
      @directories.select { |child_directory| child_directory.start_with?("#{directory}/") }.each do |child_directory|
        @directories.delete(child_directory)
      end

      @directories.delete(directory)
    else
      directory_depth = directory.count('/')
      parent_directory = directory.split('/').tap(&:pop).join('/')

      if directory_depth.zero? || @directories.include?(parent_directory)
        puts "Cannot delete #{directory} - it does not exist"
      else
        puts "Cannot delete #{directory} - #{parent_directory} does not exist"
      end
    end
  end

  def list_directories
    puts LIST_COMMAND if TEST_MODE || @should_output_commands
    puts '' if @directories.empty?

    @directories.each do |directory|
      directory_depth = directory.count('/')
      indent_spaces = '  ' * directory_depth
      child_directory = directory.split('/').last

      puts "#{indent_spaces}#{child_directory}"
    end
  end

  def move_directory(from_directory, to_directory)
    puts "#{MOVE_COMMAND} #{from_directory} #{to_directory}" if TEST_MODE || @should_output_commands

    from_directory_depth = from_directory.count('/')
    child_directory = from_directory.split('/').last

    @directories.push("#{to_directory}/#{child_directory}")

    child_directories_to_move = @directories.select do |child_directory_to_move|
      child_directory_to_move.start_with?("#{from_directory}/")
    end

    child_directories_to_move.each do |child_directory_to_move|
      @directories.delete(child_directory_to_move)
      child_directory_to_move.sub!(/^#{from_directory}\//, '') if from_directory_depth.positive?
      @directories.push("#{to_directory}/#{child_directory_to_move}")
    end

    @directories.delete(from_directory)

    @directories.sort!
  end

  def check_stdin
    return unless $stdin.stat.pipe?

    @should_output_commands = true
    input = $stdin.read

    commands = input.split "\n"
    commands.each do |command|
      arguments = command.split
      run_command(*arguments)
    end

    exit
  end

  def repl_loop
    loop do
      input = $stdin.readlines.join.chomp

      exit if input.upcase == EXIT_COMMAND

      commands = input.split "\n"
      @should_output_commands = true if commands.count > 1
      puts '===== OUTPUT BELOW =====' if commands.count > 1
      commands.each do |command|
        arguments = command.split
        run_command(*arguments)
      end
      @should_output_commands = false if commands.count > 1
    end
  end
end

DirectoryTreeRepl.new.run
