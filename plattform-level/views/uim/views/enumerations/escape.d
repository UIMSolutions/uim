module views.uim.views.enumerations.escape;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

enum HTMLEscapes : string {
    NONE = "none",
    MINIMAL = "minimal",
    NEWLINE = "newline",
    QUOTES = "quotes"
}	

HTMLEscapeFlags toVibe(HTMLEscapes escape) {
    switch (escape) {
        case HTMLEscapes.MINIMAL: return HTMLEscapeFlags.escapeMinimal;
        case HTMLEscapes.NEWLINE: return HTMLEscapeFlags.escapeNewline;
        case HTMLEscapes.QUOTES: return HTMLEscapeFlags.escapeQuotes;
        default: return HTMLEscapeFlags.escapeUnknown; 
    }
}

HTMLEscapes fromVibe(HTMLEscapeFlags escape) {
    switch (escape) {
        case HTMLEscapeFlags.escapeMinimal: return HTMLEscapes.MINIMAL;
        case HTMLEscapeFlags.escapeNewline: return HTMLEscapes.NEWLINE;
        case HTMLEscapeFlags.escapeQuotes: return HTMLEscapes.QUOTES;
        default: return HTMLEscapes.NONE; 
    }
}