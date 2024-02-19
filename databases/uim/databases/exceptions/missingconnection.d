/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.databases.exceptions.missingconnection;

@safe:
import uim.databases;

// Class MissingConnectionException
class MissingConnectionException : DatabaseException {
  protected string _messageTemplate = "Connection to %s could not be established: %s";
}
