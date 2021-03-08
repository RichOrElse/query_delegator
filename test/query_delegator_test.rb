require "test_helper"

describe QueryDelegator do
  let(:invoked_call) { MiniTest::Mock.new }
  let(:invoked_new) { MiniTest::Mock.new }
  let(:instance) { @subclass.new(@object) }

  before do
    @object = OpenStruct.new(all: [])
    @subclass = Class.new(QueryDelegator) do
      def with_owner(owner)
        'with owner'
      end

      def without_owner
        'without owner'
      end
    end
  end

  describe "to_proc" do
    describe "when yielded an object" do
      subject { [@object].map(&@subclass) }

      it "must invoke new with the object" do
        invoked_new.expect :call, instance, [@object]
        @subclass.stub(:new, invoked_new) { subject }
        invoked_new.verify
      end
    end

    describe "when executed within the context of an object" do
      subject { @object.instance_exec(:next, :last, &@subclass) }

      it "must invoke call with the object and arguments" do
        invoked_call.expect :call, instance, [@object, :next, :last]
        @subclass.stub(:call, invoked_call) { subject }
        invoked_call.verify
      end
    end
  end

  describe "[]" do
    it "only accepts an instance method name" do
      assert_raises(NameError) { @subclass[:unknown] }
      assert_raises(ArgumentError) { @subclass[] }
      assert_raises(ArgumentError) { @subclass[:with_owner, :without_owner] }
    end

    it "returns a proc" do
      _(@subclass[:with_owner]).must_be_kind_of Proc
    end

    describe "when executed within the context of an object" do
      before { invoked_new.expect :call, instance, [@object] }
      after { invoked_new.verify }

      describe "with argument" do
        subject { @object.instance_exec(:owner, &@subclass[:with_owner]) }

        it "delegates method call to an instance" do
          @subclass.stub(:new, invoked_new) do
            _(subject).must_equal 'with owner'
          end
        end
      end

      describe "without argument" do
        subject { @object.instance_exec(&@subclass[:without_owner]) }

        it "delegates method call to an instance" do
          @subclass.stub(:new, invoked_new) do
            _(subject).must_equal 'without owner'
          end
        end
      end
    end
  end
end
