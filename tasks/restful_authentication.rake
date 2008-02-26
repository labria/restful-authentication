namespace :cert do
desc "Generates the CA for your application" 
task :create_ca do
  require 'lib/quick_cert'
  require 'config/initializers/cert_config'
  qc = QuickCert.new CA
end

desc "Generates a self-signeg SSL certificate for your server"
task :server_cert do
  require 'lib/quick_cert'
  require 'config/initializers/cert_config'
  qc = QuickCert.new CA
  qc.create_cert  SERVER_CERT
  puts "You can now delete the SERVER_CERT configuration from cert_config.rb"
end

end