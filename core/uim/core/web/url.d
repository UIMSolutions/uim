module uim.core.web.url;

import uim.core;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

string correctUrl(string url) {
    return url.endsWith("/") 
        ? url   
        : url ~"/";
}