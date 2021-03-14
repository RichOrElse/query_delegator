# frozen_string_literal: true
require "test_helper"

describe QueryDelegator::MemoryFetching do
  subject { subclass.new(OpenStruct.new(all: all)) }
  let(:subclass) { Class.new(QueryDelegator).include QueryDelegator::MemoryFetching }

  let(:all) { [2,3,4,5] }

  describe "fetch" do
    let(:returns) { subject.fetch(condition) }

    describe "with matching condition" do
      let(:condition) { proc(&:odd?) }
      it { _(returns).must_equal all.grep(condition).first }
    end

    describe "without matching condition" do
      let(:condition) { 100 }
      it { _(returns).must_be_nil }

      describe "and with default value" do
        let(:returns) { subject.fetch(condition, :default_value) }
        it { _(returns).must_equal :default_value }
      end

      describe "given a block" do
        let(:returns) { subject.fetch(condition) { :block_value } }
        it { _(returns).must_equal :block_value }
      end
    end
  end

  describe "#fetch_or_new" do
    let(:returns) { subject.fetch_or_new(condition, &given_block) }
    let(:given_block) { nil }

    before do
      def all.new(*) object_id end
    end

    describe "without matching condition" do
      let(:condition) { { name: 'no match' }  }
      it { _(returns).must_equal all.new }

      describe "but with given block" do
        let(:given_block) { proc(&:even?) }
        it { _(returns).must_equal all.grep(given_block).first }
      end
    end

    describe "with matching condition" do
      let(:condition) { 3 }
      it { _(returns).must_equal all.grep(condition).first }
    end
  end
end
