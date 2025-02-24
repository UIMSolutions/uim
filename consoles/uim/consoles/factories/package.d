module uim.consoles.factories;

public {
    import uim.consoles.factories.error;
    import uim.consoles.factories.input;
    import uim.consoles.factories.output;
}

static this() { // Init factories
  import uim.consoles;

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

  ErrorOutputFactory.set("file", (Json[string] options = null) @safe {
      return new DFileErrorOutput(options);
  });

  ErrorOutputFactory.set("rest", (Json[string] options = null) @safe {
      return new DRestErrorOutput(options);
  });

  ErrorOutputFactory.set("standard", (Json[string] options = null) @safe {
    return new DStandardErrorOutput(options);
  });
}
 