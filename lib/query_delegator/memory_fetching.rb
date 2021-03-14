# frozen_string_literal: true

class QueryDelegator
  module MemoryFetching
    # Returns the first record that meets the +condition+, otherwise
    # returns the given +block value+ or
    # returns +nil+ by default unless a second argument is specified.
    def fetch(condition, default_value = nil)
      grep(condition) { |found| return found }
      return yield condition if defined? yield

      default_value
    end

    # Returns the first record that meets either the +block condition+ if given or the argument +condition+, otherwise
    # returns a new record with Hash from the argument +condition+.
    def fetch_or_new(condition, &block_condition)
      fetch(block_condition || condition) { new(condition.to_h) }
    end
  end
end
