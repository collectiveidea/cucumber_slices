When 'I follow the link emailed to "$email"' do |email|
  email = find_email('To' => user.email)
  assert email
  url = email.body.scan(/(http:\/\/\S+)/).flatten.first
  assert_not_nil url
  visit url
end


Then 'an email is sent to "$email" with:' do |address, table|
  email = find_email(table.rows_hash.merge('To' => address))
  assert_not_nil email
end

def find_email(options)
  ActionMailer::Base.deliveries.reverse.detect do |email| 
    matches = true

    options.each do |field, value|
      case field.to_s.downcase
      when 'to'
        matches &&= email.to.include?(value)
      when 'subject'
        matches &&= email.subject =~ /#{Regexp.escape(value)}/
      when 'body contains'
        matches &&= email.body =~ /#{Regexp.escape(value)}/
      when 'body does not contain'
        matches &&= email.body !~ /#{Regexp.escape(value)}/
      else
        raise "The field #{field} is not supported"
      end
    end
    matches
  end
end
