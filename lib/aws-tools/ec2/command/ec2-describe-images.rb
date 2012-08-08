
require 'aws-tools'
require 'aws-tools/ec2'
require 'aws-tools/ec2/command'
require 'uri'

parser = AWSTools::EC2::OptionParser.new()
parser.store_on('-a', '--all', TrueClass, TrueClass, "Describe all AMIs, public, private or owned, that the user has access to.")
parser.store_on('-o', '--owner OWNER', String, /^.*$/, "Only AMIs owned by the users specified are described.")
parser.store_on('-x', '--executable-by USER', String, /^.*$/, "Only AMIs with launch permissions as specified are described.")
parser.store_on('-F', '--filter FILTER', String, /^.*$/, "Add a filter criterion for the result-set.")

parser.parse!(ARGV)

options = {}
options[:access_key_id] = parser.options[:access_key_id] if parser.options.include?(:access_key_id)
options[:secret_access_key] = parser.options[:secret_access_key] if parser.options.include?(:secret_access_key)
options[:ec2_endpoint] = URI.parse(parser.options[:url]).host if parser.options.include?(:url)
options[:http_open_timeout] = parser.options[:connection_timeout] if parser.options.include?(:connection_timeout)
options[:http_read_timeout] = parser.options[:request_timeout] if parser.options.include?(:request_timeout)
options[:http_wire_trace] = parser.options[:debug] if parser.options.include?(:debug)

ec2 = AWS::EC2.new(options)
images = ec2.images
images = images.with_owner(parser.options[:owner]) if parser.options[:owner]
images = images.executable_by(parser.options[:executable_by]) if parser.options[:executable_by]

images.each { |image|
# permission = (image.public?) ? "private" : "public" # FIXME: could not get permission of images.
  permission = "private"
  STDOUT.puts(<<-EOS)
IMAGE\t#{image.id}\t#{image.name}\t#{image.owner_id}\t#{image.state}\t#{permission}\t#{image.architecture}\t#{image.type}\t#{image.kernel_id}\t#{image.root_device_type}\t#{image.virtualization_type}\t#{image.hypervisor}
  EOS
  image.block_device_mappings.each { |device, attrs|
    STDOUT.puts(<<-EOS)
BLOCKDEVICE\t#{device}\t#{attrs[:snapshot_id]}\t#{attrs[:volume_size]}
    EOS
  }
  image.tags.each { |key, value|
    STDOUT.puts(<<-EOS)
TAG\timage\t#{image.id}\t#{key}\t#{value}
    EOS
  }
}

# vim:set ft=ruby :
