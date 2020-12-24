SAML_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/saml.yml")[Rails.env]

Redmine::OmniAuthSAML::Base.configure do |config|
  config.saml = {
    :assertion_consumer_service_url => "#{SAML_CONFIG['base_domain']}/auth/saml/callback", # OmniAuth callback URL
    :issuer                         => SAML_CONFIG['issuer'],      # The issuer name / entity ID. Must be an URI as per SAML 2.0 spec.
    :single_logout_service_url      => "#{SAML_CONFIG['base_domain']}/auth/saml/sls",      # The SLS (logout) callback URL
    :idp_sso_target_url             => "#{SAML_CONFIG['idp_domain']}/saml/auth", # SSO login endpoint
    :idp_cert_fingerprint           => "9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D", # SSO ssl certificate fingerprint
    # Alternatively, specify the full certifiate:
    #:idp_cert                       => "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----",
    :name_identifier_format         => "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent",
    :signout_url                    => "", # Optional signout URL, not supported by all identity providers
    :idp_slo_target_url             => "#{SAML_CONFIG['idp_domain']}/saml/logout",
    :name_identifier_value          => "mail", # Which redmine field is used as name_identifier_value for SAML logout
    :attribute_mapping              => {
    # How will we map attributes from SSO to redmine attributes
      :login      => 'extra.raw_info.name',
      :mail       => 'extra.raw_info.email',
      :firstname  => 'extra.raw_info.name',
      :lastname   => 'extra.raw_info.name'
    }
  }

  config.on_login do |omniauth_hash, user|
    # Implement any hook you want here
  end
end
