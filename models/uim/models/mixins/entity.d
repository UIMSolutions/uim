module uim.models.mixins.entity;

// #region EntityThis
string entityThis(string name = null) {
  string fullName = name ~ "Entity";
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

template EntityThis(string name = null) {
  const char[] EntityThis = entityThis(name);
}
// #endregion EntityThis

// #region EntityCalls
string entityCalls(string name) {
  string fullName = name ~ "Entity";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template EntityCalls(string name) {
  const char[] EntityCalls = entityCalls(name);
}
// #endregion EntityCalls
