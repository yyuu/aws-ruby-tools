
require 'aws-tools'
require 'aws-tools/ec2'
require 'aws-tools/ec2/command'
require 'uri'

parser = AWSTools::EC2::OptionParser.new()

parser.parse!(ARGV)

options = {}
options[:access_key_id] = parser.options[:access_key_id] if parser.options.include?(:access_key_id)
options[:secret_access_key] = parser.options[:secret_access_key] if parser.options.include?(:secret_access_key)
options[:ec2_endpoint] = URI.parse(parser.options[:url]).host if parser.options.include?(:url)
options[:http_open_timeout] = parser.options[:connection_timeout] if parser.options.include?(:connection_timeout)
options[:http_read_timeout] = parser.options[:request_timeout] if parser.options.include?(:request_timeout)
options[:http_wire_trace] = parser.options[:debug] if parser.options.include?(:debug)

ec2 = AWS::EC2.new(options)
ec2.instances.each { |instance|
  STDOUT.puts(<<-EOS)
RESERVATION\t#{instance.reservation_id}\t#{instance.owner_id}\t#{instance.security_groups.map { |sg| sg.name }.join("\t")}
INSTANCE\t#{instance.id}\t#{instance.image_id}\t#{instance.dns_name}\t#{instance.private_dns_name}\t#{instance.status}\t#{instance.key_name}\t0\t#{instance.instance_type}\t#{instance.launch_time}\t#{instance.availability_zone}\t#{instance.kernel_id}\t#{instance.monitoring}\t#{instance.ip_address}\t#{instance.private_ip_address}\t#{instance.root_device_type}\t#{instance.virtualization_type}\t#{instance.hypervisor}\tsg-XXXXXXXX\tdefault
  EOS
  instance.block_device_mappings.each { |name, attachment|
    STDOUT.puts(<<-EOS)
BLOCKDEVICE\t#{attachment.device}\t#{attachment.volume.id}\t#{attachment.volume.create_time}\ttrue
    EOS
  }
  instance.tags.each { |key, value|
    STDOUT.puts(<<-EOS)
TAG\tinstance\t#{instance.id}\t#{key}\t#{value}
    EOS
  }
}

# vim:set ft=ruby :
