module uim.consoles.classes.arguments;

import uim.consoles;

@safe:

// Provides an interface for interacting with a command`s options and arguments.
class DArguments {
  this(string[size_t] newArguments, Json[string] newOptions,  string[size_t] newNames) {
    _arguments = newArguments;
    _options = newOptions;
    _names = newNames;
  }

  // #region arguments
    // Positional argument name map
    protected string[size_t] _names;

    size_t indexOfName(string name) {
      size_t index = -1;
      foreach(k,v; _names) {
        if (v == name) {
          index = k;
          break;
        }
      }
      return index;
    }

    // Get positional arguments by index.
    string argumentAt(size_t index) {
      return hasArgumentAt(index) 
        ? _arguments[index]
        : null;
    }

    // Positional arguments.
    protected string[size_t] _arguments;
    // Get all positional arguments.
    string[size_t] arguments() {
      return _arguments;
    }

    // Check if a positional argument exists
    bool hasArgumentAt(size_t index) {
      return _arguments.hasKey(index);
    }

    // Check if a positional argument exists by name
    bool hasArgument(string name) {
      size_t index = indexOfName(name);
      return index < 0
        ? false
        : arguments.hasKey(index);
    }

    // Check if a positional argument exists by name
    string argument(string name) {
      size_t index = indexOfName(name);
      return index < 0 || !_arguments.hasKey(index)
        ? null
        : _arguments[index];
    }
  // #endregion arguments

  // #region options
    protected Json[string] _options;
    // Get an array of all the options

    Json[string] options() {
      return _options.dup;
    }

    // Get an option`s value or null
    Json option(string name) {
      return _options.getJson(name);
    }

    // Check if an option is defined and not null.
    bool hasOption(string name) {
      return _options.hasKey(name);
    }
  // #endregion options
}
