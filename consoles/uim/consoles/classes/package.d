/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes;

public {
  import uim.consoles.classes.arguments;
  import uim.consoles.classes.helpformatter;
}

public {
  import uim.consoles.classes.consoles;
  import uim.consoles.classes.error;
  import uim.consoles.classes.factories;
  import uim.consoles.classes.inputs;
  import uim.consoles.classes.outputs;
}

static this() { // Init 
  import uim.core;

  InputFactory.set("file", (Json[string] options = null) @safe {
      return new DFileInput(options);
  });

  InputFactory.set("rest", (Json[string] options = null) @safe {
    return new DRestInput(options);
  });

  InputFactory.set("standard", (Json[string] options = null) @safe {
      return new DStandardInput(options);
  });

  OutputFactory.set("file", (Json[string] options = null) @safe {
      return new DFileOutput(options);
  });

  OutputFactory.set("rest", (Json[string] options = null) @safe {
      return new DRestOutput(options);
  });

  OutputFactory.set("standard", (Json[string] options = null) @safe {
    return new DStandardOutput(options);
  });
}
