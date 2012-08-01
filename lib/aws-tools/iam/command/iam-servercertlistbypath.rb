
require 'aws-tools'
require 'aws-tools/iam'
require 'aws-tools/iam/command'
require 'uri'

parser = AWSTools::IAM::OptionParser.new()

parser.parse!(ARGV)

options = {}
options[:access_key_id] = parser.options[:access_key_id] if parser.options.include?(:access_key_id)
options[:secret_access_key] = parser.options[:secret_access_key] if parser.options.include?(:secret_access_key)
options[:iam_endpoint] = URI.parse(parser.options[:url]).host if parser.options.include?(:url)
options[:http_wire_trace] = parser.options[:debug] if parser.options.include?(:debug)

iam = AWS::IAM.new(options)
iam.server_certificates.each { |cert|
  STDOUT.puts(cert.arn)
}

# vim:set ft=ruby :
