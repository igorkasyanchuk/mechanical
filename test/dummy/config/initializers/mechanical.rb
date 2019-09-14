Mechanical.setup do |config|

  model "Account" do |model|
    field :name, type: :string
    field :balance, type: :integer

    has_many :posts

    validates :name, presence: true
    validates :balance, numericality: true
  end

  model "Post" do |model|
    field :title, type: :string
    field :published_on, type: :date
    field :account_id, type: :integer

    belongs_to :account, optional: true

    has_one_attached :file

    validates :title, presence: true

    after_create :say_hello

    add_methods do
      def self.total_posts
        self.count
      end

      def title_uppercase
        title&.upcase
      end

      def say_hello
        puts "HELLO"
        puts "HELLO"
        puts "HELLO"
        puts "HELLO"
        puts "HELLO"
      end
    end
  end

end