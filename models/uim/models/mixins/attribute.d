module uim.models.mixins.attribute;

import uim.models;
@safe: 

string attributeThis(string name = null) {
    string fullName = name ~ "Attribute";
    return objThis(fullName);
}

template AttributeThis(string name = null) {
    const char[] AttributeThis = attributeThis(name);
}

string attributeCalls(string name) {
    string fullName = name ~ "Attribute";
    return objCalls(fullName);
}

template AttributeCalls(string name) {
    const char[] AttributeCalls = attributeCalls(name);
}

/* Old

template AttributeThis(string name = null) {
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