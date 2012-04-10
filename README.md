# Spinning Cursor

Spinning Cursor is a tiny library that allows you to easily produce a
waiting/loading message for your Ruby command line program, when a more
complex solution, such as a progress bar, doesn't fit your needs.

Inspired by Chris Wanstrath's
[Choice](http://https://github.com/defunkt/choice), Spinning Cursor provides you with a _sexy_ DSL for easy use of the library.

## Installation

As easy as RubyGems:

```
$ gem install spinning_cursor --pre
```

## Usage

It's so simple it hurts!

### Example

```ruby
# my_awesome_ruby_class.rb

require 'spinning_cursor' # you'll definitely need this bit

SpinningCursor.start do
  banner "An amazing task is happening"
  type :spinner
  action do
    # Zzz
    sleep 10
  end
  message "Huh?! I'm awake!"
end
```

It's as easy as that!

### Options

* `banner` - This displays before the cursor. Defaults to "Loading".
* `type` - The type of spinner (currently only `:dots` and `:spinner`).
  Defaults to `:spinner`.
* `action` - The stuff you want to do whilst the spinner is spinning.
* `message` - The message you want to show the user once the task is finished.
  Defaults to "Done".

#### But the `action` block would get too messy!

Fear not, lost soul. There are two ways to prevent messy code as a result of
the block.

1. Call a method
2. Start and stop the cursor manually

The first option is the simplest, but the second isn't so bad either.
It's pretty simple, just do:

```ruby
SpinningCursor.start do
  banner "Loading"
  type :dots
  message "Done"
end

# Complex code that takes a long time
sleep 20

SpinningCursor.stop
```

**Notice** the absence of the `action` option. The start method will only keep
the cursor running if an `action` block isn't passed into it.

### I want to be able to change the finish message conditionally!

Do you? Well that's easy too (I'm starting to see a pattern here...)!

Use the `set_message` method to change the message during the execution:

```ruby
SpinningCursor.start do
  banner "Calculating your favour colour, please wait"
  type :dots
  action do
    sleep 20
    if you_are_romantic
      SpinningCursor.set_message "Your favourite colour is pink."
    elsif you_are_peaceful
      SpinningCursor.set_message "Your favourite colour is blue."
    else
      SpinningCursor.set_message "Can't figure it out =[!"
    end
  end
end
```

You get the message. (see what I did there?)

## Contributing to Spinning Cursor
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
