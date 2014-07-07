%w(Date Time).each do |class_name|
  "#{class_name}::DATE_FORMATS".constantize.merge!(
    :compact   => '%m/%d/%Y %I:%M %p',
    :compact_date => '%m/%d/%Y',
    :compact_time => '%I:%M %p',
    :verbose => '%A, %B %d, %Y at %I:%M %p',
    :verbose_date => '%A, %B %d, %Y',
    :month_and_year => '%B %Y'
  )
end