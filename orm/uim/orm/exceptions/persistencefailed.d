/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.orm.exceptions.persistencefailed;

import uim.orm;

@safe:
// Used when a strict save or delete fails
class DPersistenceFailedException : DORMException {
    mixin(ExceptionThis!("PersistenceFailed"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        // TODO this.messageTemplate("...");

        return true;
    }

    mixin(ExceptionCalls!("PersistenceFailed"));

    // The entity on which the persistence operation failed
    protected IORMEntity _entity;

    protected string _messageTemplate = "Entity %s failure.";

    this(IORMEntity entity, string[] myMessage, int errorCode = null, Throwable previousException = null) {
        string[] errors = Hash.flatten(entity.getErrors()).byKeyValue.each!(kv => kv.key ~ ": \"" ~ kv.value ~ "\"");
        if (errors) {
            message ~= errors.join(", ");
            _messageTemplate = "Entity %s failure. Found the following errors (%s).";
        }
        super(message, errorCode, previousException);
    }

    this(IORMEntity anEntity, string message, int errorCode = null, Throwable previousException = null) {
        _entity = entity;
        super(message, errorCode, previousException);
    }

    // Get the passed in entity
    IORMEntity getEntity() {
        return _entity;
    } 
}
