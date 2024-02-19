module source.uim.orm.exceptions.missingtableclass;

import uim.orm;

@safe:

// Exception raised when a Table could not be found.
class MissingTableClassException : UIMException {
    protected string _messageTemplate = "Table class %s could not be found.";
}
