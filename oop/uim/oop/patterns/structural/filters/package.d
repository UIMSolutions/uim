/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.patterns.filters;

import uim.oop;
@safe:

class Person {
  this(string name, string gender, string maritalStatus) {
    _name = name;
    _gender = gender;
    _maritalStatus = maritalStatus;		
  }

  private string _name;
  @property string name() { return _name; }

  private string _gender;
  @property string gender() { return _gender; }

  private string _maritalStatus;
  @property string maritalStatus() { return _maritalStatus; }	
}

interface ICriteria {
  Person[] meetCriteria(Person[] persons);
}

class CriteriaMale : ICriteria {
  override Person[] meetCriteria(Person[] persons) {
    return persons.filter!(a => a.gender.toLower == "male").array;
  }
}

class CriteriaFemale : ICriteria {
  override Person[] meetCriteria(Person[] persons) {
    return persons.filter!(a => a.gender.toLower == "female").array;
  }
}

 class CriteriaSingle : ICriteria {
   override Person[] meetCriteria(Person[] persons) {
      return persons.filter!(a => a.maritalStatus.toLower == "single").array;
   }
}

 class AndCriteria : ICriteria {
   private ICriteria _criteria;
   private ICriteria _otherCriteria;

    this(ICriteria criteria, ICriteria otherCriteria) {
      _criteria = criteria;
      _otherCriteria = otherCriteria; 
   }

   override Person[] meetCriteria(Person[] persons) {
      return _otherCriteria.meetCriteria(
        _criteria.meetCriteria(persons));
   }
}

 class OrCriteria : ICriteria {
   private ICriteria _criteria;
   private ICriteria _otherCriteria;

    this(ICriteria criteria, ICriteria otherCriteria) {
      _criteria = criteria;
      _otherCriteria = otherCriteria; 
   }

  override Person[] meetCriteria(Person[] persons) {
    Person[] firstCriteriaItems = _criteria.meetCriteria(persons);
    Person[] otherCriteriaItems = _otherCriteria.meetCriteria(persons);

    return otherCriteriaItems
      .filter!(person => !firstCriteriaItems.hasPerson(person)) 
      .array;
  }
}

void printPersons(Person[] persons) {
  foreach (person; persons) {
    writeln("Person : [ Name : ", person.name, ", Gender : ", person.gender, ", Marital Status : ", person.maritalStatus, " ]");
  }
} 

bool hasPerson(Person[] persons, Person person) {
  foreach(p; persons) if (p is person) { return true; }
  return false;
}

version(test_uim_oop) { unittest {
    Person[] persons;

  persons ~= (new Person("Robert","Male", "Single"));
  persons ~= (new Person("John", "Male", "Married"));
  persons ~= (new Person("Laura", "Female", "Married"));
  persons ~= (new Person("Diana", "Female", "Single"));
  persons ~= (new Person("Mike", "Male", "Single"));
  persons ~= (new Person("Bobby", "Male", "Single"));

  ICriteria male = new CriteriaMale();
  ICriteria female = new CriteriaFemale();
  ICriteria single = new CriteriaSingle();
  ICriteria singleMale = new AndCriteria(single, male);
  ICriteria singleOrFemale = new OrCriteria(single, female);

  writeln("Males: ");
  printPersons(male.meetCriteria(persons));

  writeln("\nFemales: ");
  printPersons(female.meetCriteria(persons));

  writeln("\nSingle Males: ");
  printPersons(singleMale.meetCriteria(persons));

  writeln("\nSingle Or Females: ");
  printPersons(singleOrFemale.meetCriteria(persons));
}}