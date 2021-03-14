require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object"
require "query_delegator/version"
require "query_delegator/memory_fetching"
require "query_delegator/be"

class QueryDelegator
  delegate_missing_to :@current_scope

  def initialize(relation)
    @current_scope = relation.all
  end

  class << self
    # Returns a Proc which wraps an ActiveRecord scope in a new query object instance.
    def to_proc
      delegator = self

      proc do |*args|
        if equal? delegator
          new(*args)
        else
          delegator.(self, *args)
        end
      end
    end

    # Returns a Proc which delegates an ActiveRecord model scope to query object instance method.
    def [](delegating)
      delegator = self

      if public_instance_method(delegating).arity.zero?
        proc do
          delegator.new(self).public_send delegating
        end
      else
        proc do |*options|
          delegator.new(self).public_send delegating, *options
        end
      end
    end

    alias_method :call, :new
  end
end
