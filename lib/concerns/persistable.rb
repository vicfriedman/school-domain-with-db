module Persistable
  def self.included(base)
    base.send(:extend, Persistable::ClassMethods)
    base.send(:include, Persistable::InstanceMethods)
    base.send(:attr_accessor, *base.attributes.keys)
  end

  module ClassMethods
    def table_name
      to_s.downcase + "s"
    end

    def create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS #{self.table_name} (
          #{schema_definition}
        )
      SQL
      DB[:conn].execute(sql)
    end

    def schema_definition
      attributes.collect{|k,v| "#{k} #{v}"}.join(",")
    end

    def drop_table
      sql = "DROP TABLE IF EXISTS #{self.table_name}"
      DB[:conn].execute(sql)
    end    

    def new_from_db(row)
      self.new.tap do |s|
        row.each_with_index do |value, index|
          s.send("#{attributes.keys[index]}=", value)
        end
      end
    end

    def find_by_name(name)
      sql = "SELECT * FROM #{self.table_name} WHERE name = ?"
      result = DB[:conn].execute(sql,name)[0] #[]    
      self.new_from_db(result) if result
    end
  end
  
  module InstanceMethods
    def sql_for_update
      self.class.attributes.keys[1..-1].collect{|k| "#{k} = ?"}.join(",")
    end

    def attribute_values
      self.class.attributes.keys[1..-1].collect{|key| self.send(key)}
    end

    def question_marks_for_sql
      ("?," * self.class.attributes.keys[1..-1].size).chop
    end

    def insert
      sql = "INSERT INTO #{self.class.table_name} (#{self.class.attributes.keys[1..-1].join(",")}) VALUES (#{question_marks_for_sql})"
      DB[:conn].execute(sql, *attribute_values)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{self.class.table_name}")[0][0]
    end

    def update
      sql = "UPDATE #{self.class.table_name} SET #{sql_for_update} WHERE id = ?"
      DB[:conn].execute(sql, *attribute_values, id)
    end    

    def persisted?
      self.id
    end

    def save
      persisted? ? update : insert
    end
  end
end


  