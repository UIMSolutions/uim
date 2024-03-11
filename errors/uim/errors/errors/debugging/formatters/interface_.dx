/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.debugs;

@safe:
import uim.errors;

/**
 * Interface for formatters used by Debugger::exportVar()
 *
 * @unstable This interface is not stable and may change in the future.
 */
interface IFormatter {
    /**
     * Convert a tree of IERRNode objects into a plain text string.
     * aNode - The node tree to dump.
     */
    string dump(IERRNode aNode);

    /**
     * Output a dump wrapper with location context.
     *
     * aContent - The content to wrap and return
     * @param array myLocation The file and line the contents came from.
     */
    string formatWrapper(string aContent, array myLocation);
}
