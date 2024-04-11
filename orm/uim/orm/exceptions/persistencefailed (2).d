module uim.orm.Exception;

import uim.orm;

@safe:

// Used when a strict save or delete fails
class DPersistenceFailedException : UimException {
    // The entity on which the persistence operation failed
    protected IEntity my_entity;
 
    protected string _messageTemplate = "Entity %s failure.";

    /**
     * Constructor.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity on which the persistence operation failed
     * @param string[]|string mymessage Either the string of the error message, or an array of attributes
     *  that are made available in the view, and sprintf()"d into Exception::_messageTemplate
     * @param int|null mycode The code of the error, is also the HTTP status code for the error.
     * @param \Throwable|null myprevious the previous exception.
     */
    this(
        IEntity myentity,
        array|string mymessage,
        int mycode = null,
        ?Throwable myprevious = null
    ) {
       _entity = myentity;
        if (mymessage.isArray) {
            string[] myerrors;
            foreach (Hash.flatten(myentity.getErrors()) as myfield: myerror) {
                myerrors ~= myfield ~ ": "" ~ myerror ~ """;
            }
            if (myerrors) {
                mymessage ~= myerrors.join(", ");
               _messageTemplate = "Entity %s failure. Found the following errors (%s).";
            }
        }
        super(mymessage, mycode, myprevious);
    }

    // Get the passed in entity
    IEntity getEntity() {
        return _entity;
    }
}
