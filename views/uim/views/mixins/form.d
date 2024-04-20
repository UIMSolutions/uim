module uim.forms.mixins.form;

string formThis(string name) {
    string fullName = name ~ "Form";
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

template FormThis(string name) {
    const char[] FormThis = formThis(name);
}

string formCalls(string name) {
    string fullName = name ~ "Form";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template FormCalls(string name) {
    const char[] FormCalls = formCalls(name);
}
