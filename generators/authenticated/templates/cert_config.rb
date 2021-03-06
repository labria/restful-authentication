CA = {}

full_hostname = `hostname`.strip
domainname = full_hostname.split('.')[1..-1].join('.')
hostname = full_hostname.split('.')[0]

CA[:hostname] = hostname
CA[:domainname] = domainname
CA[:CA_dir] = "#{RAILS_ROOT}/cert/CA"
CA[:password] = '1234'

CA[:keypair_file] = File.join CA[:CA_dir], "private/cakeypair.pem"
CA[:cert_file] = File.join CA[:CA_dir], "cacert.pem"
CA[:serial_file] = File.join CA[:CA_dir], "serial"
CA[:new_certs_dir] = File.join CA[:CA_dir], "newcerts"
CA[:new_keypair_dir] = File.join CA[:CA_dir], "private/keypair_backup"
CA[:crl_dir] = File.join CA[:CA_dir], "crl"

CA[:ca_cert_days] ||= 5 * 365 # five years
CA[:ca_rsa_key_length] ||= 2048

CA[:cert_days] ||= 365 # one year
CA[:cert_key_length_min] ||= 1024
CA[:cert_key_length_max] ||= 2048

CA[:crl_file] ||= File.join CA[:crl_dir], "#{CA[:hostname]}.crl"
CA[:crl_pem_file] ||= File.join CA[:crl_dir], "#{CA[:hostname]}.pem"
CA[:crl_days] ||= 14

if CA[:name].nil?
  CA[:name] = [
    ['C', 'US', OpenSSL::ASN1::PRINTABLESTRING],
    ['O', CA[:domainname], OpenSSL::ASN1::UTF8STRING],
    ['OU', CA[:hostname], OpenSSL::ASN1::UTF8STRING],
  ]
end

# Modify this if you want to create a self-signed server certifice
# After editing run "rake cert:server_cert"
SERVER_CERT = {
 :type => 'server',
 :hostname => 'test.com',
 :password => '5678',
}