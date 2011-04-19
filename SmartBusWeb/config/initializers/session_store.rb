# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SmartBusWeb_session',
  :secret      => 'e8f8ee24cd46bc762ad44be22f40af4c6fc2440e64703ac2becd3e260b11b4763bb7654c5281c547d9bfea382603a7c6f2a102d862efc5b7ad0091de0ff6d8d7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
