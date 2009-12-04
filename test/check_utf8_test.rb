require 'test_helper'

class CheckUtf8Test < ActiveSupport::TestCase
  load_schema
  class TestString < ActiveRecord::Base
  end

  test "valid utf8 logs debug" do
    CheckUtf8.any_instance.expects(:debug)
    TestString.new(:test => "\302\245").save!
  end

  test "nil is valid" do
    CheckUtf8.any_instance.expects(:debug)
    TestString.new(:test => nil).save!
  end

  test "invalid utf8 logs warning" do
    CheckUtf8.any_instance.expects(:warn)
    TestString.new(:test => "\777").save!
  end

  def make_bomb
    bomb_value = Object.new
    class << bomb_value
      def to_s
        raise "exception!"
      end
    end
    bomb_value
  end

  test "string check exception is caught" do
    assert_nothing_raised do
      TestString.new(:test => make_bomb).save!
    end
  end

  test "string check exception logs error" do
    CheckUtf8.any_instance.expects(:error)
    TestString.new(:test => make_bomb).save!
  end
end
