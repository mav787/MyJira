OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '994305370624-5f8gevhjelhgi2n6lirlfhu2fl7qgpmc.apps.googleusercontent.com', 'Hlia5UM_D0dGis3denCDl-Kd', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
