/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.exceptions.list;

import uim.oop;
@safe:

class UimExceptionList {
  this() {}

  bool initialize(/* IData[string] configSettings = null */) {}  
}
auto ExceptionList() { return new UimExceptionList; }