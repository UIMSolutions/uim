module uim.orm.exceptions;

import uim.orm;

@safe:
// Used when a strict save or delete fails
class PersistenceFailedException : DORMException {
    /**
     * The entity on which the persistence operation failed
     *
     * @var DORMdatasources.IEntity
     */
    protected _entity;


    protected _messageTemplate = "Entity %s failure.";

    /**
     * Constructor.
     *
     * @param DORMDatasource\IEntity anEntity The entity on which the persistence operation failed
     * @param array<string>|string message Either the string of the error message, or an array of attributes
     *   that are made available in the view, and sprintf()"d into Exception::_messageTemplate
     * @param int|null code The code of the error, is also the HTTP status code for the error.
     * @param \Throwable|null previous the previous exception.
     */
    this(IEntity anEntity, message, Nullable!int code = null, ?Throwable previous = null) {
        _entity = entity;
        if (is_array(message)) {
            errors = null;
            foreach (Hash::flatten(entity.getErrors()) as field: error) {
                errors[] = field ~ ": "" ~ error ~ """;
            }
            if (errors) {
                message[] = implode(", ", errors);
                _messageTemplate = "Entity %s failure. Found the following errors (%s).";
            }
        }
        super((message, code, previous);
    }

    /**
     * Get the passed in entity
     *
     * @return DORMDatasource\IEntity
     */
    function getEntity(): IEntity
    {
        return _entity;
    }
}
