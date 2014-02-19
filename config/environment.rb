require 'sqlite3'
require_relative '../lib/concerns/persistable'
require_relative '../lib/student'
require_relative '../lib/semester'
require_relative '../lib/school'

DB = {:conn => SQLite3::Database.new("db/students.db")}
