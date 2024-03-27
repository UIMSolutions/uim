/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.architecturals.transfer;
/**
Source Wikipedia [EN]: 
In the field of programming a data transfer object (DTO[1][2]) is an object that carries data between processes. The motivation for its use is that communication between processes is usually done resorting to remote interfaces (e.g., web services), where each call is an expensive operation.[2] Because the majority of the cost of each call is related to the round-trip time between the client and the server, one way of reducing the number of calls is to use an object (the DTO) that aggregates the data that would have been transferred by the several calls, but that is served by one call only.[2]
The difference between data transfer objects and business objects or data access objects is that a DTO does not have any behavior except for storage, retrieval, serialization and deserialization of its own data (mutators, accessors, parsers and serializers). In other words, DTOs are simple objects that should not contain any business logic but may contain serialization and deserialization mechanisms for transferring data over the wire.[1]
This pattern is often incorrectly used outside of remote interfaces. This has triggered a response from its author[3] where he reiterates that the whole purpose of DTOs is to shift data in expensive remote calls.

Source Wikipedia [DE]: 
Das Transferobjekt oder Datentransferobjekt (Abkürzung DTO) ist ein Entwurfsmuster aus dem Bereich der Softwareentwicklung. 
Es bündelt mehrere Daten in einem Objekt, sodass sie durch einen einzigen Programmaufruf übertragen werden können. Transferobjekte werden in verteilten Systemen eingesetzt, um mehrere zeitintensive Fernzugriffe durch einen einzigen zu ersetzen.
**/
import uim.oop;
@safe:

/// Create Transfer Object.
class DStudentVO {
  this(string newName, int newId) {
    this.name = newName;
    this.id = newId;
  }

  mixin(OProperty!("string", "name"));
  mixin(OProperty!("int", "id"));
}

/// Create Business Object.
class DStudentBO {
  //list is working as a database
  DStudentVO[] _students;

  this() {
    _students = null;
    DStudentVO student1 = new DStudentVO("Michael",0);
    DStudentVO student2 = new DStudentVO("Peter",1);
    _students ~= student1;
    _students ~= student2;		
  }
  void deleteStudent(DStudentVO student) {
    _students.remove(student.id());
    writeln("Student: Id ", student.id, ", deleted from database");
  }

  //retrive list of students from the database
  auto allStudents() { return _students; }

  DStudentVO getStudent(int id) {
    foreach(s; _students) if (s.id == id) return s;
    return null;
  }

  void updateStudent(DStudentVO student) {
    getStudent(student.id()).name(student.name());
    writeln("Student: Id ", student.id, ", updated in the database");
  }
}

/// Use the DStudentBO to demonstrate Transfer Object Design Pattern.
version(test_uim_oop) { unittest {
    DStudentBO studentBusinessObject = new DStudentBO();

  //print all students
  foreach(student; studentBusinessObject.allStudents()) {
      writeln("Student: [Id : ", student.id, ", Name : ",  student.name, " ]");
  }

  //update student
  DStudentVO student = studentBusinessObject.getStudent(0);
  student.name("Michael");
  studentBusinessObject.updateStudent(student);

  //get the student
  student = studentBusinessObject.getStudent(0);
  writeln("Student: [Id : ", student.id, ", Name : ", student.name, " ]");
}}
