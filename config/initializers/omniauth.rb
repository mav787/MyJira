OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '994305370624-kgulhbl1f7bqf4pe4jes289nauhi78q3.apps.googleusercontent.com', 'TNdIOWNzBD38635RmQvJUgts', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
