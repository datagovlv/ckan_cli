#!/usr/bin/env ruby
# frozen_string_literal: true

lib_path = File.expand_path('../lib', __dir__)
$:.unshift(lib_path) if !$:.include?(lib_path)
require 'ckancli/cli'

Signal.trap('INT') do
  warn("\n#{caller.join("\n")}: interrupted")
  exit(1)
end

begin
  Ckancli::CLI.start
rescue Ckancli::CLI::Error => err
  puts "ERROR: #{err.message}"
  exit 1
end
