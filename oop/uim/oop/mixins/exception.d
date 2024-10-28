/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.exception;

import uim.oop;

@safe:
string exceptionThis(string exceptionName) {
  string fullName = exceptionName~"Exception";

  return `
  this() {
    super();
    this.name("`~fullName~`");
  }

  this(
    string msg,
    string file = __FILE__,
    size_t line = cast(size_t) __LINE__,
    Throwable nextInChain = null
 ) {
    super(msg, file, line, nextInChain);
    this.name("`~fullName~`");
  }
  `;
} 

template ExceptionThis(string exceptionName) {
  const char[] ExceptionThis = exceptionThis(exceptionName);
}

string exceptionCalls(string exceptionName) {
  auto name = exceptionName~"Exception";

  return "
auto "~name~"() { return new D"~name~"();  }
  ";
} 

template ExceptionCalls(string exceptionName) {
  const char[] ExceptionCalls = exceptionCalls(exceptionName);
}
