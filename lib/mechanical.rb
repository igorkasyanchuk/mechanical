require "mechanical/engine"
require 'activemodel-form'
require 'simple_form'
require 'active_attr'
require 'ostruct'

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
    attr_reader :name, :options
    def initialize(name, *options)
      @name    = name
      @options = options
    end
  end

  class DummyKlass
  end

  class Model
    attr_reader :fields, :name, :options, :model, :form

    def initialize(name)
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

        delegate_missing_to :__storage

        def __storage
          @__storage ||= OpenStruct.new(data)
        end
      end

      @form = Class.new(DummyKlass) do
        extend ActiveModel::Naming
        include ActiveAttr::TypecastedAttributes
        include ActiveAttr::BasicModel
        include ActiveAttr::Model

        @@this = this
        @@model = @model

        def self.model_name
          ActiveModel::Name.new(self, nil, @@this.name.downcase)
        end

        attribute :first_name, :type => String
        attribute :last_name, :type => String
        validates :first_name, presence: true

        def create
          @@this.model.create(data: attributes)
        end
      end
    end
    
    def field(name, *options, &block)
      @fields[name] = Field.new(name, options)
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
