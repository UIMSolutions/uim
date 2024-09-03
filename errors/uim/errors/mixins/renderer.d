module uim.renderers.mixins.renderer;

string rendererThis(string name = null) {
    string fullName = `"` ~ name ~ "Renderer" ~`"`;
    return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template RendererThis(string name = null) {
    const char[] RendererThis = rendererThis(name);
}

string rendererCalls(string name) {
    string fullName = name ~ "Renderer";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template RendererCalls(string name) {
    const char[] RendererCalls = rendererCalls(name);
}
