require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "./student"

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: "test_reports/html",
    output_filename: "StudentSpecTests.html",
  ),
]

describe Student do
  after do
    Student.students.clear
    Student.class_variable_set(:@@students_set, Set[])
  end

  let(:student) { Student.new("Andrii", "Khokhotva", "28-04-2006") }
  let(:student_copy) { Student.new("Andrii", "Khokhotva", "28-04-2006") }

  describe "attributes" do
    describe "name" do
      it "should be correctly initialized and accessible for reading" do
        expect(student.name).must_equal("Andrii")
      end
    end

    describe "surname" do
      it "should be correctly initialized and accessible for reading" do
        expect(student.surname).must_equal("Khokhotva")
      end
    end

    describe "date_of_birth" do
      it "should be correctly initialized and accessible for reading" do
        expect(student.date_of_birth).must_equal(Date.new(2006, 4, 28))
      end

      it "should not be in the future" do
        expect {
          Date.stub :today, Date.new(2024, 11, 5) do
            not_born_student = Student.new("Test", "Student", "01-01-2025")
          end
        }.must_raise ArgumentError
      end
    end    
  end

  describe "instances" do
    it 'should be equal if they have the same name, surname and birth date' do
      expect(student.eql?(student_copy)).must_equal(true)
    end
  end

  describe "#calculate_age" do
    let(:student2) { Student.new("Andrii", "Tesla", "28-11-2000") }

    it "should return correct age" do
      Date.stub :today, Date.new(2024, 11, 5) do
        expect(student.calculate_age).must_equal(18)
        expect(student2.calculate_age).must_equal(23)
      end
    end
  end
  
  describe "#add_student" do
    it "should add a new student to the students array" do
      Student.add_student(student)
      expect(Student.students).must_include(student)
    end

    it "should raise an ArgumentError if student already exists" do
      Student.add_student(student)
      expect { Student.add_student(student_copy) }.must_raise ArgumentError
    end
  end

  describe "#delete_student" do
    it "should delete the student from the students array" do
      Student.add_student(student)
      Student.delete_student(student)
      expect(Student.students).wont_include(student)
    end

    it "should raise an ArgumentError if student is not in the students array" do
      expect { Student.delete_student(student) }.must_raise ArgumentError
    end
  end

  let(:student2) { Student.new("Andrii", "Tesla", "28-11-2000") }
  let(:student3) { Student.new("Isaac", "Newton", "01-01-2006") }

  describe "#get_students_by_age" do
    it "should only return students with the given age" do
      [student, student2, student3].each { |s| Student.add_student(s) }
      Date.stub :today, Date.new(2024, 11, 5) do
        students_aged_18 = Set.new(Student.get_students_by_age(18))
        expect(students_aged_18).must_equal(Set.new([student, student3]))
      end
    end
  end

  describe "#get_students_by_name" do
    it "should only return students with the given name" do
      [student, student2, student3].each { |s| Student.add_student(s) }
      Date.stub :today, Date.new(2024, 11, 5) do
        students_named_andrii = Set.new(Student.get_students_by_name("Andrii"))
        expect(students_named_andrii).must_equal(Set.new([student, student2]))
      end
    end
  end
end