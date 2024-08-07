module uim.errors.classes.renderers.html.error;

import uim.errors;

@safe:

/*
 * Interactive HTML error rendering with a stack trace.
 *
 * Default output renderer for non CLI SAPI.
 */
class DHtmlErrorRenderer : IErrorRenderer {
    // Output to stdout which is the server response.
    void write(string outputText) {
        writeln(outputText);
    }
 
    string render(UIMError error, bool shouldDebug) {
        if (!debug) {
            return null;
        }
        string anId = "uimErr" ~ uniqid();
        file = error.getFile();

        // Some of the error data is not HTML safe so we escape everything.
        Json description = htmlAttributeEscape(error.message());
        Json somePath = htmlAttributeEscape(file);
        Json trace = htmlAttributeEscape(error.getTraceAsString());
        auto line = error.getLine();

        string errorMessage = "<b>%s</b> (%s)"
            .format(h(capitalize(error.getLabel())), htmlAttributeEscape(error.code())
       );
        toggle = this.renderToggle(errorMessage,  anId, "trace");
        codeToggle = this.renderToggle("Code",  anId, "code");

        excerpt = null;
        if (file && line) {
            excerpt = Debugger.excerpt(file, line, 1);
        }
        string code = excerpt.join("\n");

        return <<<HTML
<div class="uim-error">
    {toggle}: {description} [in <b>{somePath}</b>, line <b>{line}</b>]
    <div id="{ anId}-trace" class="uim-stack-trace" style="display: none;">
        {codeToggle}
        <pre id="{ anId}-code" class="uim-code-dump" style="display: none;">{code}</pre>
        <pre class="uim-trace">{trace}</pre>
    </div>
</div>
HTML;
    }
    
    // Render a toggle link in the error content.
    private string renderToggle(string textToInsert, string errorId, string elementSelector) {
        string selector = errorId ~ "-" ~ elementSelector;
        
        return `<<<HTML
<a href="javascript:void(0);"
  onclick="document.getElementById("{selector}").style.display = (document.getElementById("{selector}").style.display == "none' ? "" : 'none")"
>
    {textToInsert}
</a>
HTML`;
        
    } 
}
