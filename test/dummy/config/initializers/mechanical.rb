Mechanical.setup do |config|

  model "Account" do
    field :name, type: :string
    field :balance, type: :integer

    has_many :posts

    validates :name, presence: true
    validates :balance, numericality: true
  end

  model "Post" do
    field :title, type: :string
    field :description, type: :text
    field :published_on, type: :date
    field :account_id, type: :integer
    field :active, type: :boolean, default: true

    belongs_to :account, optional: true

    has_one_attached :file

    validates :title, presence: true

    scope :active, -> { jsonb_where(:mechanical_data, active: true) }

    after_create :say_hello

    add_methods do
      def self.total_posts
        self.count
      end

      def title_uppercase
        title&.upcase
      end

      def say_hello
        puts "HELLO FROM initializer #{self}"
      end
    end
  end

end