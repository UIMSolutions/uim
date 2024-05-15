/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.iterators;

import uim.oop;
@safe:

//// Create interfaces.
interface Iterator {
  bool hasNext();
  string next();
}

interface IContainer {
  Iterator iterator();
}

/// Create concrete class implementing the Container interface. This class has inner class DNameIterator implementing the Iterator interface.
class DNameRepository : IContainer {
  string[] names = ["Robert" , "John" ,"Julie" , "Lora"];

  override Iterator iterator() {
    return new DNameIterator(); }

  private class DNameIterator : Iterator {
    size_t _index;

    override bool hasNext() {
      return _index < names.length; }

    override string next() {
      return hasNext ? names[_index++] : null; }		
  }
}

/// Use the NameRepository to get iterator and print names.
version(test_uim_oop) { unittest {
  writeln("IteratorPatternDemo"); 
  
  auto namesRepository = new DNameRepository();

  for(Iterator iter = namesRepository.iterator(); iter.hasNext();) {
    string name = to!string(iter.next());
    writeln("Name : "~name); } 	
  }
}