require 'test_helper'

class Mechanical::Test < ActiveSupport::TestCase
  test "sql" do
    assert_equal Mechanical::Model::Post.all.to_sql, "SELECT \"mechanical_mechanical_stores\".* FROM \"mechanical_mechanical_stores\" WHERE \"mechanical_mechanical_stores\".\"mechanical_model_type\" = 'Mechanical::Model::Post'"
    assert_equal Mechanical::Model::Post.count, 0
  end

  test 'storage' do
    assert_equal Mechanical::Model::Post.count, 0

    post = Mechanical::Model::Post.create(title: "Hello world", description: "this is description")

    assert post.persisted?

    assert_equal post.title, "Hello world"
    assert_equal post.description, "this is description"

    post.reload

    assert_equal post.title, "Hello world"
    assert_equal post.description, "this is description"

    assert_equal Mechanical::Model::Post.count, 1
  end

  test 'two different models' do
    assert_equal Mechanical::Model::Post.count, 0
    assert_equal Mechanical::Model::Account.count, 0

    Mechanical::Model::Post.create(title: "Hello world", description: "this is description")
    Mechanical::Model::Account.create(name: "XYZ", balance: 100)
    
    assert_equal Mechanical::Model::Post.count, 1
    assert_equal Mechanical::Model::Account.count, 1

    Mechanical::Model::Post.destroy_all

    assert_equal Mechanical::Model::Post.count, 0
    assert_equal Mechanical::Model::Account.count, 1
  end

  # for querying use: https://github.com/madeintandem/jsonb_accessor
  test 'query' do
    Mechanical::Model::Post.create(title: "ABC", description: "this is description")
    Mechanical::Model::Post.create(title: "TRE", description: "this is second description")
    Mechanical::Model::Account.create(name: "XYZ", balance: 100)
    Mechanical::Model::Account.create(name: "MTR", balance: 200)

    assert_equal Mechanical::Model::Post.jsonb_where(:mechanical_data, { title: 'ABC' }).count, 1
    assert_equal Mechanical::Model::Account.mechanical_data_where(balance: { greater_than_or_equal_to: 150 }).count, 1
    assert_equal Mechanical::Model::Account.mechanical_data_where(balance: 10..250).count, 2
  end
end
