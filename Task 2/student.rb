require 'date'
require 'set'

class Student
  @@students = []
  @@students_set = Set[]
  attr_reader :name, :surname, :date_of_birth

  def self.students
    @@students
  end

  def self.add_student(student)
    if @@students_set.include?(student)
      raise ArgumentError, "Student already exists"
    end
    @@students << student
    @@students_set << student
    return nil
  end

  def self.delete_student(student)
    if @@students.delete(student).nil?
      raise ArgumentError, "Student doesn't exist"
    end
    @@students_set.delete(student)
    return nil
  end

  def self.get_students_by_age(age)
    @@students.filter { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.filter { |student| student.name == name }
  end
   
  def initialize(name, surname, date_of_birth)
    @name = name
    @surname = surname

    parsed_date = Date.strptime(date_of_birth, "%d-%m-%Y")
    self.date_of_birth = parsed_date
  end

  def eql?(other)
    @name == other.name &&
    @surname == other.surname &&
    @date_of_birth == other.date_of_birth
  end

  def hash
    [@name, @surname, @date_of_birth].hash
  end

  def calculate_age
    if @age.nil?
      @age = Date.today.year - @date_of_birth.year
      @age -= 1 if @date_of_birth.next_year(@age) > Date.today
    end
    @age
  end

  private

  def date_of_birth=(date_of_birth)
    if date_of_birth > Date.today
      raise ArgumentError, "Date of birth is in the future"
    end
    @date_of_birth = date_of_birth
  end
end

if __FILE__ == $0
  student1 = Student.new("Andrii", "Khokhotva", "28-04-2006")
  student2 = Student.new("Andrii", "Tesla", "28-04-2007")
  student3 = Student.new("Isaac", "Newton", "01-01-2006")
  student1_copy = Student.new("Andrii", "Khokhotva", "28-04-2006")

  [student1, student2, student3].each do |st|
    def st.to_s
      "Name: #{@name}, Surname: #{@surname}, " +
      "Age: #{calculate_age}, Date of Birth: #{@date_of_birth}"
    end
    Student.add_student(st)
  end

  puts "All Students:\n", Student.students.join("\n"), "\n"
  puts "Students with age 18:\n", Student.get_students_by_age(18).join("\n"), "\n"
  puts "Students named Andrii:\n", Student.get_students_by_name("Andrii").join("\n"), "\n"

  begin
    Student.add_student(student1_copy)
  rescue ArgumentError => e
    puts "Unable to add student1 copy: " + e.message, "\n"
  end

  Student.delete_student(student1)
  puts "After deleting student1:"
  puts Student.students.join("\n"), "\n"

  begin
    Student.delete_student(student1)
  rescue ArgumentError => e
    puts "Unable to delete student1: " + e.message, "\n"
  end

  begin
    not_born_student = Student.new("Нейм", "Сюрнеймович", "01-01-2025")
  rescue ArgumentError => e
    puts "Unable to create student: " + e.message
  end
end