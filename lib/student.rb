require 'pry'
class Student
	attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

	def self.create_table
	  sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        tagline TEXT,
        github TEXT,
        twitter TEXT,
        blog_url TEXT,
        image_url TEXT,
        biography TEXT
   	  )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
        DROP TABLE IF EXISTS students;
      SQL
      DB[:conn].execute(sql)
    end

    def insert
      sql = <<-SQL
        INSERT INTO students (name,tagline,github,twitter,blog_url,image_url,biography)
      	VALUES
      	(?,?,?,?,?,?,?)
      SQL
      DB[:conn].execute(sql, [name,tagline,github,twitter,blog_url,image_url,biography])
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

   def self.new_from_db(row)
    self.new.tap do |s|
      s.id = row[0]
      s.name =  row[1]
      s.tagline = row[2]
      s.github =  row[3]
      s.twitter =  row[4]
      s.blog_url =  row[5]
      s.image_url = row[6]
      s.biography = row[7]
    end
  end	

  def self.find_by_name(name)
  	sql = <<-SQL
  		SELECT * FROM students where name = ?;
  	SQL
  	# binding.pry
  	student = DB[:conn].execute(sql, name)[0] 
    self.new_from_db(student) if student
  end

  def persisted?
    !!self.id
  end

  def save
    persisted? ? update : insert
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?,tagline = ?,github = ?,twitter = ?,blog_url = ?,image_url = ?,biography = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, [name,tagline,github,twitter,blog_url,image_url,biography], id)
  end



end
