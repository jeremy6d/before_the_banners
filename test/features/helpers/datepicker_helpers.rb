module FeatureHelpers
  module DatepickerHelpers
    def pick_date locator, sought_date
      sought_date = Date.parse(sought_date.to_s) unless sought_date.is_a? Date

      sought_month_and_year = Date.new sought_date.year, sought_date.month, 1

      find('label', text: locator).trigger("click") # partial covering over input, so just bypass by triggering event manually

      within("#ui-datepicker-div") do
        current_month_and_year = Date.parse find(".ui-datepicker-title").text

        while (current_month_and_year = Date.parse(find(".ui-datepicker-title").text)) != sought_month_and_year
          case 
          when current_month_and_year > sought_month_and_year
            find(".ui-datepicker-header a", text: "Prev").click
          when current_month_and_year < sought_month_and_year
            find(".ui-datepicker-header a", text: "Next").click
          else
            raise "error state reached"
          end
        end

        find("a", text: /^#{sought_date.day}$/).click
      end
    end
  end
end