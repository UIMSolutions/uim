module uim.views.mixins.view;

import uim.views;

@safe:

string viewThis(string name) {
  string fullName = name ~ "View";
  return `this() { super(); this.name("`~ fullName ~ `"); }`;
}

template ViewThis(string name) {
  const char[] ViewThis = viewThis(name);
}

string viewCalls(string name) {
  string fullName = name ~ "View";
  return `auto ` ~ fullName ~ `() { return new D` ~ fullName ~ `(); }`;
}

template ViewCalls(string name) {
  const char[] ViewCalls = viewChis(name);
}
