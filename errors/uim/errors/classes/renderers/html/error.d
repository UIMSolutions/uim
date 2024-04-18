module uim.errors.classes.renderers.html.error;

import uim.errors;

@safe:

/*
 * Interactive HTML error rendering with a stack trace.
 *
 * Default output renderer for non CLI SAPI.
 */
class DHtmlErrorRenderer : IErrorRenderer {
    /* 
    void write(string aout) {
        // Output to stdout which is the server response.
        writeln(result);
    }
 
    string render(UimError error, bool shouldDebug) {
        if (!debug) {
            return "";
        }
        string anId = "uimErr" ~ uniqid();
        file = error.getFile();

        // Some of the error data is not HTML safe so we escape everything.
        description = htmlAttribEscape(error.getMessage());
        somePath = htmlAttribEscape(file);
        trace = htmlAttribEscape(error.getTraceAsString());
        line = error.getLine();

        errorMessage = "<b>%s</b> (%s)"
            .format(h(ucfirst(error.getLabel())), htmlAttribEscape(error.getCode())
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
    
    /**
     * Render a toggle link in the error content.
     * Params:
     * @param string aid The error id scope.
     * @param string asuffix The element selector.
     * /
    private string renderToggle(string textToInsert, string aid, string asuffix) {
        string selector = anId ~ "-" ~ suffix;
        
        return <<<HTML
<a href="javascript:void(0);"
  onclick="document.getElementById("{selector}").style.display = (document.getElementById("{selector}").style.display == "none' ? "" : 'none")"
>
    {textToInsert}
</a>
HTML;
        
    } */ 
}
