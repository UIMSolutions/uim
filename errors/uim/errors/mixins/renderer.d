/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.mixins.renderer;

string rendererThis(string name = null) {
    string fullName = name ~ "Renderer";
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
