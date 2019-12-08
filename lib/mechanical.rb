require "mechanical/engine"
require 'simple_form'
require 'ostruct'
require 'jsonb_accessor'

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
      model.model.jsonb_accessor :mechanical_data, name.to_sym => [options[:type].presence || String, default: options[:default]]
    end

    def validates(options = {})
      model.model.send :validates, name.to_sym, options
    end

  end

  class Model
    attr_reader :fields, :name, :options, :model

    delegate_missing_to :model

    def initialize(name, options = {})
      @name    = name
      @fields  = {}
      @options = options
      @model   = eval %{
        class #{name} < ApplicationRecord
          self.table_name = "mechanical_mechanical_stores"
          def self.model_name; ActiveModel::Name.new(self, nil, "#{name.downcase}"); end

          default_scope -> { where(mechanical_model_type: name) }

          belongs_to :user, optional: true, foreign_key: :mechanical_user_id
          belongs_to :mechanicalable, polymorphic: true, optional: true
        end
        #{name}
      }

      puts "Initiated => #{@model}"
    end
    
    def field(name, options = {}, &block)
      @fields[name] = Field.new(self, name, options)
    end

    def add_methods(&block)
      @model.class_eval(&block)
    end
  end

  mattr_accessor :schema
  @@schema = Schema.new
  
  def self.setup(&block)
    setup_active_storage
    schema.instance_eval(&block)
  end

  def self.[](name)
    schema[name]
  end

  private

  def self.setup_active_storage
    ApplicationRecord.send :include, ActiveStorage::Reflection::ActiveRecordExtensions
    ApplicationRecord.send :include, ActiveStorage::Attached::Model
    ::ActiveRecord::Reflection.singleton_class.prepend(::ActiveStorage::Reflection::ReflectionExtension)
  end

end
