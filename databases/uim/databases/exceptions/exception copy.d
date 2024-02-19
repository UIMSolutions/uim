/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.databases.uim.databases.exceptions.exception copy;

import uim.databases;

@safe:
// Exception for the database package.
class DatabaseException : DException {
	protected string _messageTemplate = "%s";
}
