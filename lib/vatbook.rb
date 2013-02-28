%w{vatbook/version vatbook/book_fetcher vatbook/booking}.each { |lib| require lib }

class String
  def vatbook(args={})
    Vatbook.bookings(self, args)
  end
end

module Vatbook

  def self.bookings(fir, args)
    BookFetcher.new(fir, args).fetch
  end

end