# frozen_string_literal: true
require "test_helper"

describe QueryDelegator::Be do
  subject { subclass.new OpenStruct.new(all: scope) }
  let(:scope) { OpenStruct.new(none: [], all: 1..9) }
  let(:subclass) { Class.new(QueryDelegator).include QueryDelegator::Be }

  describe "#be" do
    before do
      def subject.be_matching_method; object_id end
    end

    describe "with matching method" do
      let(:returns) { subject.be('matching method') }
      it { _(returns).must_equal subject.be_matching_method }
    end

    describe "without matching method" do
      let(:returns) { subject.be('something else') }
      it { _(returns).must_equal scope.none }
    end

    describe "with blank" do
      let(:returns) { subject.be('') }
      it { _(returns).must_equal scope.all }
    end
  end
end
