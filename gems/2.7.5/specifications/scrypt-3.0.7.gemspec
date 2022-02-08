# -*- encoding: utf-8 -*-
# stub: scrypt 3.0.7 ruby lib
# stub: ext/scrypt/Rakefile

Gem::Specification.new do |s|
  s.name = "scrypt".freeze
  s.version = "3.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Patrick Hogan".freeze, "Stephen von Takach".freeze, "Rene van Paassen".freeze, "Johanns Gregorian".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIEfDCCAuSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBCMQ4wDAYDVQQDDAVzdGV2\nZTEbMBkGCgmSJomT8ixkARkWC2FjYXByb2plY3RzMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTE5MTExMzIzMDMwMFoXDTIwMTExMjIzMDMwMFowQjEOMAwGA1UEAwwF\nc3RldmUxGzAZBgoJkiaJk/IsZAEZFgthY2Fwcm9qZWN0czETMBEGCgmSJomT8ixk\nARkWA2NvbTCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBALtarCg2Ux+m\nXjcGQ6XVxRbVwwVUxGWIBfpKXzq23WOXk0NkRooyYLuxSfkA/PFVd5OLZTMP+ULr\nKgM9w7+xR/Xhs/qxib/84u54H8rqHTCozYmldR5QpYTwsB4BeG0HpSbD0PGL+4N+\noa50wRyvwVBAZMG4F4QYUGnQlwBpLSm4Fhm6xhKqD9DDhbS5jgIg/S3Cr4dqghUG\nkqsIGjKd6X9wIOIqF1IWLZkXiwN1IcKCJ9FO2iTBEo7UidJXROO5xs5D0Vr3iyiw\nF3tmhpq1C7KkXkv0AxAxRK3SmdpIiagRukvdNFEAcpkgX6qUg62G8KMRGc3dP9lx\ntBP8IonLEcpLktQakuqsV4YETQaKQb5F4WADxh1tvIPcYJUxHsw3sdHZeDywT3De\nLPCNTbuBseIF33hj2qiZ77XMusgVxiqG1eaCD0X58zeVTd7ZDZUFuVKlgAudhyOi\nO30rMiCHNIchQqwVNLah0Tu4KAF7PGAwJhu01qMXOEl9WCEtApOS6wIDAQABo30w\nezAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHQ4EFgQUjrc6E0haseLehiw2\nJME0lZzbYKMwIAYDVR0RBBkwF4EVc3RldmVAYWNhcHJvamVjdHMuY29tMCAGA1Ud\nEgQZMBeBFXN0ZXZlQGFjYXByb2plY3RzLmNvbTANBgkqhkiG9w0BAQsFAAOCAYEA\nfpmwkaIoCUA8A5IDHTcGWDX5gFYwhrRLMPwvdbU3r9RUeo7slWjek1OCAH4gyLUM\nK+OeWIYyQjOzeRHllNapY3AnOWbwXX7rVrYa0OxFd8JgXgVS/XJR4elzNJ0lb8En\nszSDkj4xl2Yn7FDZBsT+Oq19zMKFZNSF3SYumTuLMq3AdJa3vO2Gg4I1r8oSfZBB\n5V81o2GU9YTGCNrl57dmq+Iop1qVU9jF60wEXyiOz/Fkhvk+kdz2PveH8nhlpBiw\nt3kOzg645P903giemoqlYZJ1XTmBqHLhflfTSxNie6my4izqFQgB9UxtUeesRtaJ\n5y48Vz2twr2OQfw+1lM//SY/H9rPJkaOPDM7AlPodnZvYrr1hAlwXUebgmOq+Mvm\n13PWwCGItI0lMBPfAfadtZKJQNvzl4K4Iq76ksQy3tobcrYw1r4cKTyqvrrrKhWn\n93B950TkkA8h64SLwNEzV3ayjvGKTI95l0cz0B1STPIwvQecQI2j1y8/DzyztNXO\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2019-11-14"
  s.description = "    The scrypt key derivation function is designed to be far\n    more secure against hardware brute-force attacks than\n    alternative functions such as PBKDF2 or bcrypt.\n".freeze
  s.email = ["pbhogan@gmail.com".freeze, "steve@advancedcontrol.com.au".freeze, "rene.vanpaassen@gmail.com".freeze, "io+scrypt@jsg.io".freeze]
  s.extensions = ["ext/scrypt/Rakefile".freeze]
  s.files = ["ext/scrypt/Rakefile".freeze]
  s.homepage = "https://github.com/pbhogan/scrypt".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.2.31".freeze
  s.summary = "scrypt password hashing algorithm.".freeze

  s.installed_by_version = "3.2.31" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ffi-compiler>.freeze, [">= 1.0", "< 2.0"])
    s.add_development_dependency(%q<awesome_print>.freeze, [">= 1", "< 2"])
    s.add_development_dependency(%q<rake>.freeze, [">= 9", "< 13"])
    s.add_development_dependency(%q<rdoc>.freeze, [">= 4", "< 5"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 3", "< 4"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0.76.0", "< 1.0.0"])
    s.add_development_dependency(%q<rubocop-gitlab-security>.freeze, [">= 0.1.1", "< 0.2"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 1.5.0", "< 1.6.0"])
  else
    s.add_dependency(%q<ffi-compiler>.freeze, [">= 1.0", "< 2.0"])
    s.add_dependency(%q<awesome_print>.freeze, [">= 1", "< 2"])
    s.add_dependency(%q<rake>.freeze, [">= 9", "< 13"])
    s.add_dependency(%q<rdoc>.freeze, [">= 4", "< 5"])
    s.add_dependency(%q<rspec>.freeze, [">= 3", "< 4"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0.76.0", "< 1.0.0"])
    s.add_dependency(%q<rubocop-gitlab-security>.freeze, [">= 0.1.1", "< 0.2"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 1.5.0", "< 1.6.0"])
  end
end
