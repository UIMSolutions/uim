module uim.orm.uim.orm.exceptions.exception copy;

import uim.orm;

@safe:
class ORMException : UIMException {
    protected string _messageTemplate = "Exception in uim.orm";
}