Rails.application.config.middleware.user OmniAuth::Builder do
  provider :linkedin, ENV["LI_KEY"], ENV["LI_SECRET"], :fields => ['id', 'email-address', 'first-name', 'last-name', 'location', 'industry']
end
