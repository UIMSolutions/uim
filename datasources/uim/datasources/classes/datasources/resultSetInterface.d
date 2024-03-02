/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources;

@safe:
import uim.datasources;

use Countable;
use Serializable;

/**
 * Describes how a collection of datasource results should look like
 */
interface IResultSet : ICollection, Countable, Serializable
{
}