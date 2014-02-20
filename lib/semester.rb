class Semester
  ATTRIBUTES = {
    :id => "INTEGER PRIMARY KEY",
    :name => "TEXT"
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