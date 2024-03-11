/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.debugs.nodes;

@safe:
import uim.errors;

/**
 * Debug node for special messages like errors or recursion warnings.
 */
class SpecialNode : IERRNode {
    /**
     * @var string
     */
    private myValue;

    /**
     * Constructor
     *
     * @param string myValue The message/value to include in dump results.
     */
    this(string myValue) {
        this.value = myValue;
    }

    /**
     * Get the message/value
     */
    string value() {
        return this.value;
    }


    IERRNode[] getChildren() {
        return [];
    }
}
