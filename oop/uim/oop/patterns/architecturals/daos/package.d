/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.daos;

import uim.oop;
@safe:

class DStudent {
  private string _name;
  private int _id;

  this(string newName, int newId) {
    this.name = newName;
    this.id = newId;
  }

  // Get property name
  @property string name() { return _name; }
  // Set property name
  @property void name(string newName) { _name = newName; }

  // Get property id
  @property int id() { return _id; }
  // Set property id
  @property void id(int newId) { _id = newId; }
}

interface IStudentDao {
  DStudent[] allStudents();
  DStudent student(int id);

  void updateStudent(DStudent student);
  void deleteStudent(DStudent student);
}

class DStudentDao : IStudentDao {	
  //list is working as a database
  DStudent[] _students;

  this() {
    _students = null;
    auto student1 = new DStudent("Robert",0);
    auto student2 = new DStudent("John",1);
    _students ~= student1;
    _students ~= student2;		
  }

  override void deleteStudent(DStudent student) {
    _students.remove(student.id);
    writeln("Student: Id ", student.id, ", deleted from database");
  }

  //retrive list of students from the database
  override DStudent[] allStudents() { return _students; }

  override DStudent student(int id) {
    foreach(stud; _students) if (stud && stud.id == id) return stud;
    return null;
  }

  override void updateStudent(DStudent aStudent) {
    student(aStudent.id).name(aStudent.name);
    writeln("Student with Id ", aStudent.id, ", updated in the database");
  }
}

version(test_uim_oop) { unittest {
      writeln("DaoPatternDemo");

  DStudentDao studentDao = new DStudentDao();

  //print all students
  foreach (student; studentDao.allStudents()) {
    writeln("Student: [Id : ", student.id, ", Name : ", student.name, " ]");
  }

  //update student
  auto student = studentDao.student(0);
  student.name("Michael");
  studentDao.updateStudent(student);

  //get the student
  studentDao.student(0);
  writeln("Student: [Id : ", student.id, ", Name : ", student.name, " ]");		
}
}