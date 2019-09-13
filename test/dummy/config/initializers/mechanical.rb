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
    field :first_name, type: :string
    field :last_name, type: :string
    field :age, type: :integer

    validates :first_name, presence: true
    validates :age, numericality: true
  end

  model "Post" do |model|
    field :title, type: :string
    field :published_on, type: :date

    validates :title, presence: true
  end

end