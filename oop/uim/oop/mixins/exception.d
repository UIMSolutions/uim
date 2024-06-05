/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
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
    ulong line = cast(ulong) __LINE__,
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
