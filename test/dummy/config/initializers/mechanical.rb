Mechanical.setup do |config|
  # BigDecimal
  # Boolean
  # Date
  # DateTime
  # Float
  # Integer
  # Object
  # String

  model "User" do |model|
    field :first_name, type: String
    field :last_name, type: String
    field :age, type: Integer
  end

  model "Post" do |model|
    field :title, type: String
    field :published_on, type: Date
  end

end