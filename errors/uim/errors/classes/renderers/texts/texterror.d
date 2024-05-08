/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.renderers.texts.texterror;

@safe:
import uim.errors;

/**
 * Plain text error rendering with a stack trace.
 *
 * Useful in CLI environments.
 */
class DTextErrorRenderer { // }: IErrorRenderer {
      mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    
  
  void write(string outputText) {
    writeln(outputText);
  }

  string render(DError anError, bool isDebug) {
    if (!isDebug) { return ""; }

    // isDebug
    return 
      "%s: %s . %s on line %s of %s\nTrace:\n%s".format(
        error.getLabel(),
        error.getCode(),
        error.getMessage(),
        error.getLine() ?? "",
        error.getFile() ?? "",
        error.getTraceAsString());
  } */
}
