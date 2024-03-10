/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.persistencefailed;

import uim.orm;

@safe:
// Used when a strict save or delete fails
class DPersistenceFailedException : DORMException {
    	mixin(ExceptionThis!("PersistenceFailed"));

	override bool initialize(IData[string] initData = null) {
		if (!super.initialize(initData)) {
			return false;
		}

		// TODO this.messageTemplate("...");

		return true;
	}
}

mixin(ExceptionCalls!("PersistenceFailed"));		
    // TODO
    /**
     * The entity on which the persistence operation failed
     *
     * @var DORMdatasources.IEntity
     * /
    protected _entity;


    protected _messageTemplate = "Entity %s failure.";

    /**
     * Constructor.
     *
     * @param DORMDatasource\IEntity anEntity The entity on which the persistence operation failed
     * @param array<string>|string myMessage Either the string of the error message, or an array of attributes
     *   that are made available in the view, and sprintf()"d into Exception::_messageTemplate
     * @param int|null code The code of the error, is also the HTTP status code for the error.
     * @param \Throwable|null previous the previous exception.
     * /
    this(IEntity anEntity, myMessage, Nullable!int code = null, ?Throwable previous = null) {
        _entity = entity;
        if (is_array(myMessage)) {
            myErrors = null;
            foreach (Hash::flatten(entity.getErrors()) as myField: myError) {
                myErrors[] = myField ~ ": "" ~ myError ~ """;
            }
            if (myErrors) {
                myMessage[] = implode(", ", myErrors);
                _messageTemplate = "Entity %s failure. Found the following errors (%s).";
            }
        }
        super(myMessage, code, previous);
    }

    // Get the passed in entity
    IEntity getEntity() {
        return _entity;
    } */

