module uim.consoles.classes.commands.command;

import uim.consoles;

@safe:

class DCommand : ICommand {
  // Default error code
  static const int CODE_ERROR = 1;

  // Default success code
  static const int CODE_SUCCESS = 0;

  mixin(TProperty!("string", "name"));
}
