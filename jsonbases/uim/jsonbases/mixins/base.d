module uim.jsonbases.mixins.base;

import uim.jsonbases;

@safe:
string jsonBaseThis(string aName) {
  return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
  `;
}

template JsonBaseThis(string aName) {
  const char[] JsonBaseThis = jsonBaseThis(aName);
}

string jsonBaseCalls(string shortName, string classname = null) {
  string clName = classname.length > 0 ? classname : "D"~shortName;

  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }
  `;
}

template JsonBaseCalls(string shortName, string classname = null) {
  const char[] JsonBaseCalls = jsonBaseCalls(shortName, classname);
}
