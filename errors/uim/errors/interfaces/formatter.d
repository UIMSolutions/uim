module uim.errors.interfaces.formatter;

import uim.errors;

@safe:

/******************************************************************************
 * Interface for formatters used by Debugger-
 *****************************************************************************/
interface IFormatter {
    // Convert a tree of INode objects into a plain text string.
    // TODO string dump(INode nodeToDump);

    /*************************************************************************
     * Output a dump wrapper with location context.
     * Params:
     * contentsToWrap = The contents to wrap and return
     * contentLocation = The file and line the contents came from.
     *************************************************************************/
    // TODO string formatWrapper(string contentsToWrap, IData contentLocation);
}
