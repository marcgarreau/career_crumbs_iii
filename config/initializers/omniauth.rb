Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, ENV["LI_KEY"], ENV["LI_SECRET"]
end
