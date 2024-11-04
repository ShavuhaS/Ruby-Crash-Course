require "minitest/autorun"
require "minitest/reporters"
require "./student"

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: "test_reports/html",
    output_filename: "StudentUnitTests.html",
  ),
]

class StudentTest < Minitest::Test
  def setup
    @student1 = Student.new("Andrii", "Khokhotva", "28-04-2006")
    @student2 = Student.new("Andrii", "Tesla", "28-11-2000")
    @student3 = Student.new("Isaac", "Newton", "01-01-2006")
    @student1_copy = Student.new("Andrii", "Khokhotva", "28-04-2006")
  end

  def teardown
    Student.students.clear
    Student.class_variable_set(:@@students_set, Set[])
  end

  def test_initialize
    msg = "Student's attributes should be correct and accessible for reading"
    assert_equal @student1.name, "Andrii", msg
    assert_equal @student1.surname, "Khokhotva", msg
    assert_equal @student1.date_of_birth, Date.new(2006, 4, 28), msg
  end

  def test_future_birth_date
    msg = "Creating a student with birth date in future should raise an ArgumentError"
    Date.stub :today, Date.new(2024, 11, 5) do
      assert_raises ArgumentError, msg do
        not_born_student = Student.new("Test", "Student", "01-01-2025")
      end
    end
  end

  def test_calculate_age
    msg = "Student.calculate_age should return correct age"
    Date.stub :today, Date.new(2024, 11, 5) do
      assert_equal @student1.calculate_age, 18, msg
      assert_equal @student2.calculate_age, 23, msg
    end
  end

  def test_students_equal
    msg = "Students with the same name, surname and date of birth should be equal"
    assert @student1.eql?(@student1_copy), msg
  end

  def test_add_new_student
    msg = "Students array should contain a new student"
    Student.add_student(@student1)
    assert_includes Student.students, @student1, msg
  end

  def test_add_student_copy
    msg = "Adding a copy of an existing student should raise an ArgumentError"
    Student.add_student(@student1)
    assert_raises ArgumentError, msg do
      Student.add_student(@student1_copy)
    end
  end

  def test_delete_student
    msg = "Student should not be in the students array after being deleted"
    Student.add_student(@student1)
    Student.delete_student(@student1)
    refute_includes Student.students, @student1, msg
  end

  def test_delete_non_added_student
    msg = "Removing a student that has not yet been added should raise an ArgumentError"
    assert_raises ArgumentError, msg do
      Student.delete_student(@student2)
    end
  end

  def test_get_students_by_age
    msg = "Student.get_students_by_age should only return students with the given age"
    [@student1, @student2, @student3].each { |s| Student.add_student(s) }
    Date.stub :today, Date.new(2024, 11, 5) do
      students_aged_18 = Set.new(Student.get_students_by_age(18))
      assert_equal students_aged_18, Set.new([@student1, @student3]), msg
    end
  end

  def test_get_students_by_name
    msg = "Student.get_students_by_name should only return students with the given name"
    [@student1, @student2, @student3].each { |s| Student.add_student(s) }
    Date.stub :today, Date.new(2024, 11, 5) do
      students_named_andrii = Set.new(Student.get_students_by_name("Andrii"))
      assert_equal students_named_andrii, Set.new([@student1, @student2]), msg
    end
  end
end