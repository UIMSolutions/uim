/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.nulls;

import uim.oop;
@safe:

/// Create an abstract class.
abstract class DAbstractCustomer {
  protected string _name;
  abstract bool isNil();
  abstract string name();
}

/// Create concrete classes extending the above class.
class DRealCustomer : DAbstractCustomer {
  this(string name) {
    _name = name;	}
  
  @property override string name() {
    return _name; }
  
  override bool isNil() {
    return false; }
}

class DNullCustomer : DAbstractCustomer {
  override string name() {
    return "Not Available in Customer Database"; }

  override bool isNil() {
    return true; }
}

/// Create CustomerFactory Class.
class DCustomerFactory {
  static const string[] names = ["Rob", "Joe", "Julie"];

  static DAbstractCustomer getCustomer(string name) {
    return names.any!(n => n.lower == name.lower)
      ? new DRealCustomer(name)
      : new DNullCustomer();
  }
}

/// Use the CustomerFactory to get either RealCustomer or NullCustomer objects based on the name of customer passed to it.
version(test_uim_oop) { unittest {
    writeln("NullPatternDemo");

    DAbstractCustomer customer1 = DCustomerFactory.getCustomer("Rob");
    DAbstractCustomer customer2 = DCustomerFactory.getCustomer("Bob");
    DAbstractCustomer customer3 = DCustomerFactory.getCustomer("Julie");
    DAbstractCustomer customer4 = DCustomerFactory.getCustomer("Laura");

    writeln("Customers");
    writeln(customer1.name);
    writeln(customer2.name);
    writeln(customer3.name);
    writeln(customer4.name);
  }
}