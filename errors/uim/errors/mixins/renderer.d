module uim.renderers.mixins.renderer;

string rendererThis(string name = null) {
    string fullName = `"` ~ name ~ "Renderer" ~`"`;
    return objThis(fullName);
}

template RendererThis(string name = null) {
    const char[] RendererThis = rendererThis(name);
}

string rendererCalls(string name) {
    string fullName = name ~ "Renderer";
    return objCalls(fullName);
}

template RendererCalls(string name) {
    const char[] RendererCalls = rendererCalls(name);
}
