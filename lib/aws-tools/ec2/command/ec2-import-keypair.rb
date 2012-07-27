
require 'aws-tools'
require 'aws-tools/ec2'
require 'aws-tools/ec2/command'
require 'uri'

parser = AWSTools::EC2::OptionParser.new()
parser.store_on('-f', '--public-key-file FILE', String, /^.*$/, "Path to a file containing the public key material to import.")

parser.parse!(ARGV)

options = {}
options[:access_key_id] = parser.options[:access_key_id] if parser.options.include?(:access_key_id)
options[:secret_access_key] = parser.options[:secret_access_key] if parser.options.include?(:secret_access_key)
options[:ec2_endpoint] = URI.parse(parser.options[:url]).host if parser.options.include?(:url)
options[:http_open_timeout] = parser.options[:connection_timeout] if parser.options.include?(:connection_timeout)
options[:http_read_timeout] = parser.options[:request_timeout] if parser.options.include?(:request_timeout)
options[:http_wire_trace] = parser.options[:debug] if parser.options.include?(:debug)

ec2 = AWS::EC2.new(options)
name = ARGV.shift
public_key = File.read(parser.options[:public_key_file])
ec2.key_pairs.import(name, public_key) if name and public_key

# vim:set ft=ruby :
