# Credit Card Processing (BT Code Challenge)

## Overview of design decisions

The program's executable is housed at `bin/credit_card_processing`, as this is a standard pattern for Ruby libraries (putting the executable in the library's `bin/` or `exe/` directory).

The program logic lives within `lib/credit_card_processing`. I created 3 primary classes: `CreditCard` and `Activity`.

`CreditCard` has instance methods `#charge` and `#credit`, which are also accessible via `CreditCard::Charge` and `CreditCard::Credit` respectively. (These 2 classes are kind of like wrappers and aren't necessary strictly speaking, but I like the idea of "initializing a charge or credit object" where the card being charged or credited is provided as an argument to `CreditCard::Charge.new(the_credit_card_to_charge)` as I think it is more legible this way.)

The `Activity` class is responsible for taking an activiy string, e.g. "Add Tom 000000 $1000", and attempting to convert that activity into the appropriate domain objects.

Invoking `Activity#save` with an activity string of "Add Tom 000000 $1000" should attempt to store a new credit card with cardholder name of "Tom", and a credit limit of $1000.

Finally, the `Runner` class manages the state of the import of transaction data from the input file. It is kind of like a bridge between `Activity` and `CreditCard`. It keeps track of a little bit of its own state, e.g. the names of the cardholders who have activity in the provided inputs. This is relevant in situations where, e.g. Tom's aforementioned credit card has an invalid number, and so we do not store that card's information, but we need to report something like `Tom: error` in the output when running our program.

## Why I chose Ruby

I am most familiar with Ruby and feel very comfortable writing "proper", test-driven, object-oriented code that is highly legible and easy to read.

## How to run the code and tests

1. Locate the archive file `cc_processing.zip` (sent as email attachment to Braintree).
1. Unarchive the source code: `unzip cc_processing.zip`
1. Move into the library directory: `cd cc_processing`
1. `bundle install` to setup dependencies
1. To run the program: `bin/credit_card_processing spec/fixtures/input.txt`, or `bin/credit_card_processing < spec/fixtures/input.txt`.
1. To run the tests: `bin/rspec` or `bundle exec rspec`
