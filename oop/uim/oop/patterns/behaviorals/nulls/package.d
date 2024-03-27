/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.nulls;

import uim.oop;
@safe:

/// Create an abstract class.
abstract class AbstractCustomer {
  protected string _name;
  abstract bool isNil();
  abstract string name();
}

/// Create concrete classes extending the above class.
class RealCustomer : AbstractCustomer {
  this(string name) {
    _name = name;	}
  
  @property override string name() {
    return _name; }
  
  override bool isNil() {
    return false; }
}

class NullCustomer : AbstractCustomer {
  override string name() {
    return "Not Available in Customer Database"; }

  override bool isNil() {
    return true; }
}

/// Create CustomerFactory Class.
class DCustomerFactory {
  static const string[] names = ["Rob", "Joe", "Julie"];

  static AbstractCustomer getCustomer(string name) {
    for (int i = 0; i < names.length; i++) {
      if (names[i].toLower == name.toLower) {
        return new RealCustomer(name);
      }
    }
    return new NullCustomer();
  }
}

/// Use the CustomerFactory to get either RealCustomer or NullCustomer objects based on the name of customer passed to it.
version(test_uim_oop) { unittest {
    writeln("NullPatternDemo");

    AbstractCustomer customer1 = CustomerFactory.getCustomer("Rob");
    AbstractCustomer customer2 = CustomerFactory.getCustomer("Bob");
    AbstractCustomer customer3 = CustomerFactory.getCustomer("Julie");
    AbstractCustomer customer4 = CustomerFactory.getCustomer("Laura");

    writeln("Customers");
    writeln(customer1.name);
    writeln(customer2.name);
    writeln(customer3.name);
    writeln(customer4.name);
  }
}