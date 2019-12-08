# Mechanical

Simple gem which allows to store multiple tables in a single table in DB (Postgres only).

It's using STI and Postgres JSONB data type.

## Usage

Create initializer `config/initializers/mechanical.rb` and define your schema below. 

You need to define attribute and it's type (it's importan to check this gem: https://github.com/madeintandem/jsonb_accessor).
In addition you can specify relations, validations, add instance or class methods. Behavior is the same as with AR model.

```ruby

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
```

After Installation you can do the following:

```ruby
  post = Mechanical::Model::Post.create(title: "Hello world", description: "this is description")
  post.persisted? # true

  post.title # "Hello world"
  post.description # "this is description"

  # for querying use: https://github.com/madeintandem/jsonb_accessor

  Mechanical::Model::Post.create(title: "ABC", description: "this is description")
  Mechanical::Model::Post.create(title: "TRE", description: "this is second description")
  Mechanical::Model::Account.create(name: "XYZ", balance: 100)
  Mechanical::Model::Account.create(name: "MTR", balance: 200)
  Mechanical::Model::Post.jsonb_where(:mechanical_data, { title: 'ABC' }).count # 1
  Mechanical::Model::Account.mechanical_data_where(balance: { greater_than_or_equal_to: 150 }).count # 1
  Mechanical::Model::Account.mechanical_data_where(balance: 10..250).count # 2
```

If you are building form and want to use this model you can do it same way as using regular model:

Example of very simple controller:

```ruby
  def index
    @post  = Mechanical::Model::Post.new
  end

  def submit_post
    @post = Mechanical::Model::Post.new(params.require(:post).permit!)
    @post.user = User.first
    @post.save
    if @post.save
      redirect_to root_path
    else
      @posts = Mechanical::Model::Post.all
      render :index
    end
  end
```

View:

```erb

<%= simple_form_for @post, url: submit_post_url, html: { novalidate: true } do |f| %>
  <%= f.error_messages %>
  <%= f.association :account %>
  <%= f.input :title %>
  <%= f.input :description %>
  <%= f.input :published_on %>
  <%= f.input :file %>
  <%= f.input :active %>
  <br/>
  <%= f.submit %>
<% end %>

```

As you can see it supports active storage.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mechanical'
```

And then execute:
```bash
$ bundle
```
## Contributing

You are welcome to contribute.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
