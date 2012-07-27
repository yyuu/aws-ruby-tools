
require 'optparse'

module AWSTools
  module EC2
    class OptionParser < ::OptionParser
      def initialize(*args)
        super

        @options = {}
        @options[:url] = ENV['EC2_URL'] if ENV['EC2_URL']
        @options[:access_key_id] = ENV['AWS_ACCESS_KEY_ID'] if ENV['AWS_ACCESS_KEY_ID']
        @options[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY'] if ENV['AWS_SECRET_ACCESS_KEY']

        self.version = AWSTools::VERSION

         store_on('-K', '--private-key KEY', String, /^.*$/, "dummy")

         store_on('-C', '--cert CERT', String, /^.*$/, "dummy")

         store_on('-U', '--url URL', String, /^.*$/, "Endpoint URL of EC2.")

         store_on('--region REGION', String, /^.*$/, "Region to use.")

         store_on('--verbose', TrueClass, TrueClass, "Verbose mode.")

#        store_on('-?', '--help', TrueClass, nil, "Display this message.")

         store_on('-H', '--headers', TrueClass, TrueClass, "Display column headers.")

         store_on('--debug', TrueClass, TrueClass, "Debug mode.")

         store_on('--show-empty-fields', TrueClass, TrueClass, "Indicate empty fields.")

         store_on('--hide-tags', TrueClass, TrueClass, "Do not display tags for tagged resources.")

         store_on('--connection-timeout TIMEOUT', Integer, Integer, "Specify a connection timeout TIMEOUT (in seconds).")

         store_on('--request-timeout TIMEOUT', Integer, Integer, "Specify a request timeout TIMEOUT (in seconds).")

         store_on('-I', '--access-key-id VALUE', String, /^.*$/, "Specify VALUE as the AWS Access Id to use.")

         store_on('-S', '--secret-key VALUE', String, /^.*$/, "Specify VALUE as the AWS Secret Key to use.")
      end
      attr_reader :options

      def store_on(*args)
        long, = args[0, args.index { |x| not(x.is_a?(String)) }].last.split
        self.on(*args) { |val|
          @options[long.gsub(/^-+/, '').gsub(/[^\w]/, '_').to_sym] = val
        }
      end
    end
  end
end


# vim:set ft=ruby :
