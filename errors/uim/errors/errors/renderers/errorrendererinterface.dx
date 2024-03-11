/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors;

/**
 * Interface for PHP error rendering implementations
 *
 * The core provided implementations of this interface are used
 * by Debugger and ErrorTrap to render PHP errors.
 */
interface IERRErrorRenderer {
    /**
     * Render output for the provided error.
     *
     * anError - The error to be rendered.
     * isDebugMode - Whether or not the application is in debug mode.
     * returns - The output to be echoed.
     */
    string render(DERRError anError, bool isDebugMode);

    /**
     * Write output to the renderer"s output stream
     *
     * outText - The content to output.
     */
    void write(string outText);
}
