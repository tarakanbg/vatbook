# Vatbook

Ruby API to the Vatbook service for reading and parsing Vatsim pilot and ATC bookings.
Booking query requests are made by FIR and individual bookings are returned as
objects, exposing a rich set of attributes. Supports excluding enroute pilot bookings.
Supports pulling pilot and atc bookings separately or as a combined hash.

[![Build Status](https://secure.travis-ci.org/tarakanbg/vatbook.png?branch=master)](http://travis-ci.org/tarakanbg/vatbook)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/tarakanbg/vatbook)
[![Gemnasium](https://gemnasium.com/tarakanbg/vatbook.png?travis)](https://gemnasium.com/tarakanbg/vatbook)


## Installation

Add this line to your application's Gemfile:

    gem 'vatbook'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vatbook

## Usage

This gem provides one public method: `vatbook`, which can be applied to
any string (or variable containing a string) representing a full or partial FIR
ICAO code.

For example if you want to retrieve all active stations (ATC positions and pilots)
for Bosnia-Herzegovina FIR (ICAO: LQSB), then you can use:

```ruby
# Attaching the method directly to a string:
"LQSB".vatbook

# Attaching the method to a variable containing a string:
fir = "LQSB"
fir.vatbook
```

### Anatomy of method returns

The `vatbook` method returns a **hash** of 2 elements: 1) the matching *atc*
bookings, 2) all matching *pilots* bookings. Each of those is an **array**, cosnsisting of
station **objects**. Each of these objects includes a number of **attributes**:

```ruby
fir.vatbook # => {:atc => [a1, a2, a3 ...], :pilots => [p1, p2, p3, p4 ...]}

fir.vatbook[:atc] #=> [a1, a2, a3 ...]
fir.vatbook[:pilots] #=> [p1, p2, p3 ...]

fir.vatbook[:atc].first #=> a1
fir.vatbook[:pilots].first #=> p1

a1.callsign #=> "LQSA_APP"
a1.name #=> "Svilen Vassilev"
a1.cid #=> "1175035"
a1.start #=> "2012-10-08 08:00:00"
a1.end #=> "2012-10-08 10:00:00"

...

p1.callsign #=> "ACH217S"
p1.name #=> "Dragomir Andonovic"
p1.cid #=> "931960"
p1.dep #=> "LQSA"
p1.arr #=> "LDSP"
p1.route #=> "VRANA L5 KENEM"
p1.aircraft #=> "AT72"
...
```

### Station attributes

Here's a complete list of the station object attributes that can be accessed:

#### Common attributes for atc and pilots:

* `cid` (VATSIM ID)
* `callsign`
* `name`
* `role` (atc or pilot)
* `fir` (the FIR ICAO used in the request)
* `start` (planned start time)
* `end` (planned end time)

#### Pilot specific attributes

* `dep` (planned departure airport)
* `arr` (planned destination airport)
* `route` (planned route)
* `aircraft` (planned aircraft type)
* `enroute` (boolean, whether or not the flight is enroute for the FIR)

### Customizing the request

The `vatbook` method can be customized by passing in a hash-style collection
of arguments. The currently supported arguments and their defaults are:

```ruby
:enroute => true     # Possible values: true, false. Default: true
```
The `:enroute => false` option can be used to exclude all booked flights that
are enroute for the selected FIR, i.e. don't originate or end on one of the FIR's
airports. Example:

```ruby
# Lets exclude all enroute pilot bookings for LQSB FIR and only display bookings
# that are outbound/inbound one of Bosnia-Herzegovina airports:

"LQSB".vatbook(:enroute => false) #=> [pilot1, pilot2, pilot3...]
```

## Changelog

### v. 0.1 - 22 October 2012

* Initial release

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure all tests pass
6. Create new Pull Request

## Credits

Copyright © 2012 [Svilen Vassilev](http://about.me/svilen)

*If you find my work useful or time-saving, you can endorse it or buy me a beer:*

[![endorse](http://api.coderwall.com/svilenv/endorse.png)](http://coderwall.com/svilenv)
[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5FR7AQA4PLD8A)

Released under the [MIT LICENSE](https://github.com/tarakanbg/vatbook/blob/master/LICENSE.txt)
