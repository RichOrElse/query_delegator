# frozen_string_literal: true
require_relative 'respond_or_none'

class QueryDelegator
  module Be
    using RespondOrNone

    # Invokes method name prefixed with +be_+, othewise
    # returns +all+ given a blank name or
    # returns +none+ when method is unrecognized.
    def be(name, *args, &blk)
      return all if name.blank?

      underscored = name.to_s.strip.underscore
                        .gsub(/[^0-9a-z _]/i, '')
                        .gsub(/\s+/, '_')

      respond_to("be_#{underscored}", *args, &blk)
    end
  end
end
