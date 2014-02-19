class School
  ATTRIBUTES = {
    :id => "INTEGER PRIMARY KEY",
    :name => "TEXT"
  }

  def self.attributes
    ATTRIBUTES
  end

  include Persistable
end