/**
Source WIkipedia [EN]:
The service locator pattern is a design pattern used in software development to encapsulate the processes involved in obtaining a service 
with a strong abstraction layer. This pattern uses a central registry known as the "service locator", which on request returns the information 
necessary to perform a certain task.[1] Proponents of the pattern say the approach simplifies component-based applications where all dependencies 
are cleanly listed at the beginning of the whole application design, consequently making traditional dependency injection a more complex way of 
connecting objects. Critics of the pattern argue that it is an anti-pattern which obscures dependencies and makes software harder to test.
**/
/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.architecturals.services_locators;

import uim.oop;
@safe:

/// Create Service interface.
interface Service {
  string name();
  void execute();
}

/// Create concrete services.
class Service1 : Service {
  void execute() {
    writeln("Executing Service1");
  }

  @property override string name() {
    return "Service1";
  }
}

class Service2 : Service {
  void execute() {
    writeln("Executing Service2");
  }

  @property override string name() {
    return "Service2";
  }
}

/// Create InitialContext for JNDI lookup
class InitialContext {
  Object lookup(string jndiName) {
    switch(jndiName.toLower) {
      case "service1":
        writeln("Looking up and creating a new Service1 object");
        return new Service1();
      case "service2": 
        writeln("Looking up and creating a new Service2 object");
        return new Service2();
      default: return null;
    }		
  }
}

/// Create Cache
class Cache {
  private Service[] _services;

  this() {
    _services = null;
  }

  Service service(string serviceName) {
    foreach (service; _services) {
      if(service.name.toLower == serviceName.toLower) {
        writeln("Returning cached  ", serviceName, " object");
        return service;
      }
    }
    return null;
  }

  void addService(Service newService) {
    bool exists = false;
    
    foreach(service; _services) {
      if(service.name.toLower == newService.name.toLower) {
        exists = true;
      }
    }
    if(!exists) _services ~= newService;
  }
}

/// Create Service Locator
class ServiceLocator {
  private static Cache _cache;

  static this() {
    _cache = new Cache();		
  }

  static Service getService(string jndiName) {
    Service service = _cache.service(jndiName);

    if (service) return service;

    InitialContext context = new InitialContext();
    Service service1 = cast(Service)context.lookup(jndiName);
    _cache.addService(service1);
    return service1;
  }
}

/// Use the ServiceLocator to demonstrate Service Locator Design Pattern.
version(test_uim_oop) { unittest {
    writeln("ServiceLocatorPatternDemo");
    
    Service service = ServiceLocator.getService("Service1");
    service.execute();
    service = ServiceLocator.getService("Service2");
    service.execute();
    service = ServiceLocator.getService("Service1");
    service.execute();
    service = ServiceLocator.getService("Service2");
    service.execute();		
  }
}
