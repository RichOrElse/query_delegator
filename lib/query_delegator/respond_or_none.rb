class QueryDelegator
  module RespondOrNone
    # Invokes a public method, otherwise
    # returns +none+ when method is unrecognized
    def respond_to(method_name, *args, &blk)
      return none unless respond_to?(method_name)

      public_send(method_name, *args, &blk)
    end

    refine ::Object do
      include RespondOrNone
    end
  end
end
