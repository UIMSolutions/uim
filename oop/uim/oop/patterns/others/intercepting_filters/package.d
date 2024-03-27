/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.patterns.intercepting_filters;

import uim.oop;
@safe:

/// Create Filter interface.
interface Filter {
  void execute(string request);
}

/// Create concrete filters.
class DAuthenticationFilter : Filter {
  void execute(string request) {
    writeln("Authenticating request: ", request);
  }
}

class DebugFilter : Filter {
  void execute(string request) {
    writeln("request log: ", request);
  }
}

/// Create Target
class DTarget {
  void execute(string request) {
    writeln("Executing request: ", request);
  }
}

/// Create Filter Chain
class FilterChain {
  private Filter[] _filters;
  private Target _target;

  void addFilter(Filter filter) {
    _filters ~= filter;
  }

  void execute(string request) {
    _filters.each!(filter => filter.execute(request));
    _target.execute(request);
  }

  @property void target(Target target) {
    _target = target;
  }
}

/// Create Filter Manager
class FilterManager {
  FilterChain _filterChain;

  this(Target target) {
    _filterChain = new FilterChain();
    _filterChain.target = target;
  }
  
  @property void filter(Filter filter) {
    _filterChain.addFilter(filter);
  }

  void filterRequest(string request) {
    _filterChain.execute(request);
  }
}

/// Create Client
class DClient {
  FilterManager _filterManager;

  @property void filterManager(FilterManager filterManager) {
    _filterManager = filterManager;
  }

  void sendRequest(string request) {
    _filterManager.filterRequest(request);
  }
}

/// Use the Client to demonstrate Intercepting Filter Design Pattern.
version(test_uim_oop) { unittest {
    writeln("InterceptingFilterDemo");
    
    FilterManager filterManager = new FilterManager(new Target());
    filterManager.filter(new AuthenticationFilter());
    filterManager.filter(new DebugFilter());

    Client client = new DClient();
    client.filterManager(filterManager);
    client.sendRequest("HOME");
  }
}