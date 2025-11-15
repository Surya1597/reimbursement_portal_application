EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP.freeze
PASSWORD_REGEX=/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])(?!.*\s).{8,25}\z/.freeze
