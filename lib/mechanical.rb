require "mechanical/engine"
require 'activemodel-form'
require 'simple_form'
require 'active_attr'
require 'ostruct'
require 'active_model_attributes'
require 'store_model'

module Mechanical
  class Schema
    attr_reader :models

    def initialize
      @models = {}
    end

    def model(name, &block)
      model = Model.new(name)
      model.instance_eval(&block)
      @models[name] = model
    end

    def [](name)
      @models[name]
    end
  end

  class Field
    attr_reader :name, :options, :model
    def initialize(model, name, options = {})
      @model   = model
      @name    = name
      @options = options
      inject
    end

    def inject
      model.form.send :attribute, name.to_sym, field_type
      model.model.class_eval %{
        def #{name}
          return nil unless data
          self.data["#{name}"]
        end
      }
    end

    def validates(options = {})
      model.form.send :validates, name.to_sym, options
    end

    def field_type
      options[:type].presence || String
    end
  end

  class DummyKlass
  end

  class Model
    attr_reader :fields, :name, :options, :model, :form

    def initialize(name, options = {})
      @name    = name
      @fields  = {}
      @options = options
      this     = self

      @model   = Class.new(ActiveRecord::Base) do
        default_scope -> { where(type: name) }
        belongs_to :user, optional: true
        def self.model_name
          ActiveModel::Name.new(self, nil, "mechanical_mechanical_stores")
        end
        self.table_name         = "mechanical_mechanical_stores"
        self.inheritance_column = nil
      end

      @form = Class.new do
        extend ActiveModel::Naming
       # include ActiveModel::Model
      #  include ActiveModel::Serialization
       # include ActiveModelAttributes
        include StoreModel::Model

        class << self; attr_accessor :__name, :__model end
        @__name, @__model = name, this.model

        def self.model_name
          ActiveModel::Name.new(self, nil, __name)
        end

        # validates :first_name, presence: true

        def save
          if valid?
            self.class.__model.create(data: attributes)
          else
            false
          end
        end

      end
    end
    
    def field(name, options = {}, &block)
      @fields[name] = Field.new(self, name, options)
    end

    def validates(name, options = {}, &block)
      @fields[name].validates(options)
    end
  end

  mattr_accessor :schema
  @@schema = Schema.new
  
  def self.setup(&block)
    schema.instance_eval(&block)
  end

  def self.[](name)
    schema[name]
  end

end
