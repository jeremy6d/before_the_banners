module FeatureHelpers
  module EmailHelpers
    def must_receive_email opts_to_check = {}
      ActionMailer::Base.deliveries.
                         select { |i|
                          opts_to_check.all? do |key, value|
                            actual = i.send(key)
                            case actual.class.to_s
                            when "Mail::AddressContainer"
                              actual.include? value
                            else
                              actual == value
                            end 
                          end
                        }.wont_be :empty?
    end

    def open_email_addressed_to addr
      @email_body = ActionMailer::Base.deliveries.
                                       select { |e| e.to == addr }.
                                       last.
                                       try :body
    end

    def click_email_link_for message
      visit email_body.match(/<a href="http:\/\/localhost:3000(.*)">#{message}<\/a>/).
                       captures.
                       first
    end

    def email_body
      @email_body ||= ActionMailer::Base.deliveries.last.body
    end

    def an_email_was_sent_with attrs = {}
      ActionMailer::Base.deliveries.last.tap do |email|
        attrs.each do |method, value|
          email.send(method).must_include value
        end
      end
    end
  end
end