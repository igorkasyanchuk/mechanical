class MechanicalGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_initializer
    template 'mechanical.rb', 'config/initializers/mechanical.rb'
    template '20190912181342_create_mechanical_mechanical_stores.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_mechanical_mechanical_stores.rb"
  end
end