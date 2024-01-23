/*********************************************************************************************************
*  Copyright: © 2015 -2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.structural.composite;

import uim.oop;
@safe:

/// Create Employee class having list of Employee objects.
 class Employee {
   private string name;
   private string dept;
   private int salary;
   private Employee[] subordinates;

   // constructor
    this(string name,string dept, int sal) {
      this.name = name;
      this.dept = dept;
      this.salary = sal;
   }

    void add(Employee e) {
      subordinates ~= e;
   }

    void remove(Employee e) {
    Employee[] newSubordinates;
    foreach(sub; subordinates) if (sub !is e) newSubordinates ~= e;
    subordinates = newSubordinates;
   }

    auto getSubordinates() {
     return subordinates;
   }

   override string toString() {
      return "Employee :[ Name : "~name~", dept : "~dept~", salary :"~to!string(salary)~" ]";
   }   
}

/// Use the Employee class to create and print employee hierarchy.
version(test_uim_oop) { unittest {
    writeln("CompositePatternDemo"); 
   
    Employee CEO = new Employee("John","CEO", 30000);
    Employee headSales = new Employee("Robert","Head Sales", 20000);
    Employee headMarketing = new Employee("Michel","Head Marketing", 20000);
    Employee clerk1 = new Employee("Laura","Marketing", 10000);
    Employee clerk2 = new Employee("Bob","Marketing", 10000);
    Employee salesExecutive1 = new Employee("Richard","Sales", 10000);
    Employee salesExecutive2 = new Employee("Rob","Sales", 10000);

    CEO.add(headSales);
    CEO.add(headMarketing);

    headSales.add(salesExecutive1);
    headSales.add(salesExecutive2);

    headMarketing.add(clerk1);
    headMarketing.add(clerk2);

    //print all employees of the organization
    writeln(CEO); 
    
    foreach (headEmployee; CEO.getSubordinates) { 
      writeln(headEmployee);         
      headEmployee.getSubordinates.each!(employee => writeln(employee));
    }	
  }
}