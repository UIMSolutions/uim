module uim.consoles.classes.arguments;

import uim.consoles;

@safe:

// Provides an interface for interacting with a command`s options and arguments.
class DArguments {
  // Positional argument name map
  protected string[int] _argNames;

  // Positional arguments.
  protected string[int] _argPositions;

  // Named options
  protected IData[string] _options;

  /**
   * Constructor
   * Params:
   * @param array<string, string|bool|null> options Named arguments
   * /
  this(array<int, string> argumentPositions, IData[string] argOptions,  array<int, string> argNames) {
    _argPositions = someArguments;
    _options = argOptions;
    this.argNames = argNames;
  }

  // Get all positional arguments.
  string[size_t] getArguments() {
    return this.args;
  }

  // Get positional arguments by index.
  string getArgumentAt(size_t argumentIndex) {
    if (!this.hasArgumentAt(argumentIndex)) {
      return null;
    }

    return this.args[anIndex];
  }

  // Check if a positional argument exists
  bool hasArgumentAt(size_t argumentIndex) {
    return isSet(this.args[argumentIndex]);
  }

  // Check if a positional argument exists by name
  bool hasArgument(string argumentName) {
    anOffset = array_search(argumentName, this.argNames, true);
    if (anOffset == false) {
      return false;
    }
    return isSet(this.args[anOffset]);
  }

  // Check if a positional argument exists by name
  string getArgument(string argumentName) {
    auto offset = array_search(argumentName, this.argNames, true);
    if (offset == false || !this.args.isSet(offset)) {
      return null;
    }
    return this.args[anOffset];
  }

  // Get an array of all the options
  array<string, string|bool|null> getOptions() {
    return this.options;
  }

  // Get an option`s value or null
  string | bool | null getOption(string optionName) | bool | null {
    return this.options.get(optionName, null);
  }

  // Check if an option is defined and not null.
  bool hasOption(string optionName) {
    return this.options.isSet(optionName);
  } */
}
