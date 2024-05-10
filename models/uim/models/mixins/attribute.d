module uim.models.mixins.attribute;

string attributeThis(string name) {
    string fullName = name ~ "attribute";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        this(); this.name(name);
    }
    this(string name, Json[string] initData) {
        this(name).initialize(initData);
    }
    `;
}

template AttributeThis(string name) {
    const char[] AttributeThis = attributeThis(name);
}

string attributeCalls(string name) {
    string fullName = name ~ "attribute";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(string name, Json[string] initData) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template AttributeCalls(string name) {
    const char[] AttributeCalls = attributeCalls(name);
}

/* Old

template AttributeThis(string name) {
  const char[] AttributeThis = q{
    this() { initialize(); this.name(name);  }
    this(Json newData) { this().fromJson(newData); }
    this(UUID myId) { this().id(myId); }
    this(string myName) { this().name(myName); }
    this(UUID myId, string myName) { this(myId).name(myName); }  
  };
}

template AttributeCalls(string name) {
  const char[] AttributeCalls = `
auto `~name~`() { return new D`~name~`();  }
auto `~name~`(Json newData) { return new D`~name~`(newData); }
auto `~name~`(UUID myId) { return new D`~name~`(myId); }
auto `~name~`(string myName) { return new D`~name~`(myName); }
auto `~name~`(UUID myId, string myName) { return new D`~name~`(myId, myName); }  
`;
} */