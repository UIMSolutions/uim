/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.mixins.exception;

import uim.oop;

@safe:
string exceptionThis(string instanceName, string className = null) {
  auto clName = (className ? className : instanceName);

  return "
this() { super(); this.name(\""~instanceName~"\"); }
this(string aMessage) { this().message(aMessage); }
this(string[] someAttributes) { this().attributes(someAttributes); }
this(string aMessage, string[] someAttributes) { this(aMessage).attributes(someAttributes); }
  ";
} 

template ExceptionThis(string instanceName, string className = null) {
  const char[] ExceptionThis = exceptionThis(instanceName, className);
}

string exceptionCalls(string shortName, string className = null) {
  auto clName = (className ? className : "D"~shortName);

  return "
auto "~shortName~"() { return new "~clName~"();  }
auto "~shortName~"(string aMessage) { return new "~clName~"(aMessage); }
auto "~shortName~"(string[] someAttributes) { return new "~clName~"(someAttributes); }
auto "~shortName~"(string aMessage, string[] someAttributes) { return new "~clName~"(aMessage, someAttributes); }
  ";
} 

template ExceptionCalls(string instanceName, string className = null) {
  const char[] ExceptionCalls = exceptionCalls(instanceName, className);
}
