require_relative 'spec_helper'

describe Semester do

  describe 'attributes' do 
    it 'has an id, name' do
      attributes = {
        :id => 1,
        :name => "Ruby004",
      }

      semester = Semester.new
      semester.id = attributes[:id]
      semester.name = attributes[:name]

      expect(semester.id).to eq(attributes[:id])
      expect(semester.name).to eq(attributes[:name])
    end
  end

  describe '.create_table' do
    it 'creates a student table' do
      Semester.drop_table
      Semester.create_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='semesters';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['semesters'])
    end
  end

  describe '::drop_table' do
    it "drops the student table" do
      Semester.create_table
      Semester.drop_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='semesters';"
      expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
    end
  end

  describe '#insert' do
    it 'inserts the semester into the database' do
      semester = Semester.new
      semester.name = "Ruby004"

      semester.insert

      select_sql = "SELECT name FROM semesters WHERE name = 'Ruby004'"
      result = DB[:conn].execute(select_sql)[0]

      expect(result[0]).to eq("Ruby004")
    end

    it 'updates the current instance with the ID of the semester from the database' do
      semester = Semester.new
      semester.name = "Ruby004"
      semester.insert

      expect(semester.id).to eq(1)
    end
  end

  describe '::new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Ruby004"]
      semester = Semester.new_from_db(row)

      expect(semester.id).to eq(row[0])
      expect(semester.name).to eq(row[1])
    end
  end

  describe '::find_by_name' do
    it 'returns an instance of semester that matches the name from the DB' do
      semester = Semester.new
      semester.name = "Ruby004"

      semester.insert

      semester_from_db = Semester.find_by_name("Ruby004")
      expect(semester_from_db.name).to eq("Ruby004")
      expect(semester_from_db).to be_an_instance_of(Semester)
    end
  end

  describe "#update" do
    it 'updates and persists a Semester in the database' do
      semester = Semester.new
      semester.name = "Ruby004"
      semester.insert

      semester.name = "RubyAWESOME"
      original_id = semester.id

      semester.update

      semester_from_db = Semester.find_by_name("Ruby004")
      expect(semester_from_db).to be_nil

      new_semester_from_db = Semester.find_by_name("RubyAWESOME")
      expect(new_semester_from_db).to be_an_instance_of(Semester)
      expect(new_semester_from_db.name).to eq("RubyAWESOME")
      expect(new_semester_from_db.id).to eq(original_id)
    end
  end

  describe '#save' do
    it "chooses the right thing on first save" do
      semester = Semester.new
      semester.name = "Ruby004"
      expect(semester).to receive(:insert)
      semester.save
    end

    it 'chooses the right thing for all others' do
      semester = Semester.new
      semester.name = "Ruby004"
      semester.save

      semester.name = "Ruby004"
      expect(semester).to receive(:update)
      semester.save      
    end
  end
end
