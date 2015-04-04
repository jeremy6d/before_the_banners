module FeatureHelpers
  module EmailHelpers
    def email_deliveries opts = {}
      ActionMailer::Base.deliveries.select do |i|
        opts.all? do |key, value|
          actual = i.send(key)
          case actual.class.to_s
          when "Mail::AddressContainer"
            actual.include? value
          else
            actual == value
          end 
        end
      end
    end

    def must_receive_email opts_to_check = {}
      email_deliveries(opts_to_check).wont_be :empty?
    end

    def open_email_addressed_to addr
      begin
        sleep 5
        @email_body = email_deliveries(to: addr).first.body 
      rescue 
        raise("No such email delivered")
      end
    end

    def click_email_link_for message
      visit email_body.match(/<a href="http:\/\/localhost:3000(.*)">#{message}<\/a>/).
                       captures.
                       first
    end

    def email_body
      @email_body ||= email_deliveries.last.body
    end

    def an_email_was_sent_with attrs = {}
      email_deliveries.last.tap do |email|
        attrs.each do |method, value|
          email.send(method).must_include value
        end
      end
    end
  end
end