class UserMailer < ActionMailer::Base

  def signup(user, domain, sent_at = Time.now)
    @subject    = 'Welcome to Librar.us'
    @body       = {:user => user, :domain => domain}
    @recipients = user.email
    @from       = 'users@'+domain
    @sent_on    = sent_at
    @headers    = {}
  end

  def reset(user, domain, sent_at = Time.now)
    @subject    = 'Reset Librari.us Password'
    @body       = {:user => user, :domain => domain}
    @recipients = user.email
    @from       = 'users@'+domain
    @sent_on    = sent_at
    @headers    = {}
  end
  
end