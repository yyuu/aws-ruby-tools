
require 'optparse'

module AWSTools
  module IAM
    class OptionParser < ::OptionParser
      def initialize(*args)
        super

        @options = {
        }

        self.version = AWSTools::VERSION

        store_on('-U', '--url SERVICEENDPOINT', String, /^.*$/, "Endpoint URL of IAM.")

        store_on('--debug', TrueClass, TrueClass, "Debug mode.")

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
