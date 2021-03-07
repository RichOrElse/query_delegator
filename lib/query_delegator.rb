require "active_support/core_ext/module/delegation"
require "query_delegator/version"

class QueryDelegator
  delegate_missing_to :all
  delegate :all, :none, to: :@relation

  def initialize(relation)
    @relation = relation
  end
end
