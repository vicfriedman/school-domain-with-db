class Student  
  ATTRIBUTES = {
    :id => "INTEGER PRIMARY KEY",
    :name => "TEXT",
    :tagline => "TEXT",
    :github =>  "TEXT",
    :twitter =>  "TEXT",
    :blog_url =>  "TEXT",
    :image_url  => "TEXT",
    :biography =>  "TEXT",
    :new_field => "TEXT"
  }

  def self.attributes
    ATTRIBUTES
  end
  
  # Hacking included for mixin
  # include Persistable
  # Using a class method with extend for mixin
  extend Persistable
  acts_as_persistable
end
