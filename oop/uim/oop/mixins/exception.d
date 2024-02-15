/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins.exception;

import uim.oop;

@safe:
string exceptionThis(string exceptionName) {
  string name = exceptionName~"Exception";

  return "
this() { super(); this.name(\""~name~"\"); }
this(string aMessage) { this().message(aMessage); }
this(Json[string] someAttributes) { this().attributes(someAttributes); }
this(string aMessage, Json[string] someAttributes) { this(aMessage).attributes(someAttributes); }
  ";
} 

template ExceptionThis(string exceptionName) {
  const char[] ExceptionThis = exceptionThis(exceptionName);
}

string exceptionCalls(string exceptionName) {
  auto name = exceptionName~"Exception";

  return "
auto "~name~"() { return new D"~name~"();  }
auto "~name~"(string aMessage) { return new D"~name~"(aMessage); }
auto "~name~"(Json[string] someAttributes) { return new D"~name~"(someAttributes); }
auto "~name~"(string aMessage, Json[string] someAttributes) { return new D"~name~"(aMessage, someAttributes); }
  ";
} 

template ExceptionCalls(string exceptionName) {
  const char[] ExceptionCalls = exceptionCalls(exceptionName);
}
