# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rb_sys/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("markdown_it_rubyfied_sample.gemspec")

RbSys::ExtensionTask.new("markdown_it_rubyfied_sample", GEMSPEC) do |ext|
  ext.lib_dir = "lib/markdown_it_rubyfied_sample"
end

task default: %i[compile spec rubocop]
