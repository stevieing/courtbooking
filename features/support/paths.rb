module NavigationHelpers
  def path_to(page_name)
    case page_name
 
    when /the home\s?page/
      '/'
    when /the courts\/(.*) page/
      page_name =~ /the courts\/(.*) page/
      courts_path($1)
    when /the bookings\/(.*) page/
      page_name =~ /the bookings\/(.*) page/
      booking_path($1)
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_'))
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)