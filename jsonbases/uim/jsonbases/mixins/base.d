module uim.jsonbases.mixins.base;

import uim.jsonbases;

@safe:
string jsonBaseThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
this(string aName) { this(); this.name(aName); }
  `;
}

template JsonBaseThis(string aName) {
  const char[] JsonBaseThis = jsonBaseThis(aName);
}

string jsonBaseCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;

  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }
  `;
}

template JsonBaseCalls(string shortName, string className = null) {
  const char[] JsonBaseCalls = jsonBaseCalls(shortName, className);
}
