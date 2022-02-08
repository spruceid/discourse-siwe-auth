require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :benchmark do
  require 'konstructor'
  require 'benchmark'

  n = 10000

  Benchmark.bm(30) do |x|
    x.report('25 def:') do
      n.times do
        Class.new do
          def one1; end
          def two1; end
          def three1; end
          def four1; end
          def five1; end

          def one2; end
          def two2; end
          def three2; end
          def four2; end
          def five2; end

          def one3; end
          def two3; end
          def three3; end
          def four3; end
          def five3; end

          def one4; end
          def two4; end
          def three4; end
          def four4; end
          def five4; end

          def one5; end
          def two5; end
          def three5; end
          def four5; end
          def five5; end
        end
      end
    end
    x.report('25 props via attr_accessor:') do
      n.times do
        Class.new do
          attr_accessor :one1, :two1, :three1, :four1, :five1,
                        :one2, :two2, :three2, :four2, :five2,
                        :one3, :two3, :three3, :four3, :five3,
                        :one4, :two4, :three4, :four4, :five4,
                        :one5, :two5, :three5, :four5, :five5
        end
      end
    end
    x.report(' 5 konstructors after:') do
      n.times do
        Class.new do
          def one; end
          def two; end
          def three; end
          def four; end
          def five; end

          konstructor :one, :two, :three, :four, :five
        end
      end
    end
    x.report(' 5 konstructors before:') do
      n.times do
        Class.new do
          konstructor :one, :two, :three, :four, :five

          def one; end
          def two; end
          def three; end
          def four; end
          def five; end
        end
      end
    end
    x.report(' 5 konstructors nameless:') do
      n.times do
        Class.new do
          konstructor
          def one; end
          konstructor
          def two; end
          konstructor
          def three; end
          konstructor
          def four; end
          konstructor
          def five; end
        end
      end
    end
  end
end