class UserMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']
  def invite(email, organization, persisted:)
    @email = email
    @organization = organization
    @url = "http://localhost:3000/users/sign_#{persisted ? "in":"up?email=#{email}"}"
    mail(to: email,
         subject: 'Welcome!')
  end
end
