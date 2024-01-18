/*********************************************************************************************************
*  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.creational.singleton;

import uim.oop;
@safe:

private static SingleObject _obj;
static this() { 
   _obj = new SingleObject();
}

/// Create a Singleton Class.
class SingleObject {

  //create an object of SingleObject

  //make the constructor private so that this class cannot be
  //instantiated
  private this() {}

  //Get the only object available
  static SingleObject obj() {
    return _obj;
  }

  void showMessage() {
    writeln("Hello World!");
  }
}

/// Get the only object from the singleton class.
version(test_uim_oop) { unittest {
     writeln("\nSingletonPatternDemo");
   //illegal construct
   //Compile Time Error: The constructor SingleObject() is not visible
   //SingleObject object = new SingleObject();

   //Get the only object available
   SingleObject object = SingleObject.obj();

   //show the message
   object.showMessage();
}}

/// Singleton implementation was taken from David Simcha.
class FastSingleton {
private:
   this() {}

   // TLS flag, each thread has its own
   static bool _instantiated;

   // "True" global
   // does not work with @safe __gshared FastSingleton _instance;
   static FastSingleton _instance;

public:
   override string toString() {
      return "I'm single";
   } 

   static FastSingleton get() {
      // Since every thread has its own _instantiated variable,
      // there is no need for synchronization here.
      if (!_instantiated) {
         synchronized (FastSingleton.classinfo) {
            if (!_instance) {
               _instance = new FastSingleton(); }
            _instantiated = true;
         }
      }
      return _instance;
   }
}
version(test_uim_oop) { unittest {
      writeln("\nSingleton D-like Demo");

      auto singleton = FastSingleton.get();
      writeln(singleton);
  }
}