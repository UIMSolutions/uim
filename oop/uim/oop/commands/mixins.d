module uim.oop.commands.mixins;

string commandThis(string name = null) {
    string fullName = `"` ~ name ~ "Command"~`"`;
    return objThis(fullName);
}

template CommandThis(string name = null) {
    const char[] CommandThis = commandThis(name);
}

string commandCalls(string name) {
    string fullName = name ~ "Command";
    return objCalls(fullName);
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}