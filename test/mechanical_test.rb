require 'test_helper'

class Mechanical::Test < ActiveSupport::TestCase
  test "sql" do
    assert_equal Mechanical::Model::Post.all.to_sql, "SELECT \"mechanical_mechanical_stores\".* FROM \"mechanical_mechanical_stores\" WHERE \"mechanical_mechanical_stores\".\"type\" = 'User'"
    assert_equal Mechanical::Model::Post.count, 0
  end
end
