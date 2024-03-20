module uim.views.mixins.view;

string viewThis(string name) {
    string fullName = name ~ "View";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template ViewThis(string name) {
    const char[] ViewThis = viewThis(name);
}

string viewCalls(string name) {
    string fullName = name ~ "View";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ViewCalls(string name) {
    const char[] ViewCalls = viewCalls(name);
}