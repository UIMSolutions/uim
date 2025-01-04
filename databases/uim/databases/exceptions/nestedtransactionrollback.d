/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.databases.exceptions.nestedtransactionrollback;

@safe:
import uim.databases;

// Class NestedTransactionRollbackException
class DNestedTransactionRollbackException : DDatabaseException {
  // TODO 
  /* this(string message = null, int statusCode = 500, Throwable previousException = null) {
    if (message.isNull) {
      message = "Cannot commit transaction - rollback() has been already called in the nested transaction";
    }
    super(message, statusCode, previousException);
  }
  */
}
