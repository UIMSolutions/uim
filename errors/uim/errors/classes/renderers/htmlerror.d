module uim.errors.classes.renderers.htmlerror;

import uim.errors;

@safe:

/*
 * Interactive HTML error rendering with a stack trace.
 *
 * Default output renderer for non CLI SAPI.
 */
class HtmlErrorRenderer { // }: IErrorRenderer {
    /* 
    void write(string aout) {
        // Output to stdout which is the server response.
        echo  result;
    }
 
    string render(UimError error, bool debug) {
        if (!debug) {
            return "";
        }
         anId = "cakeErr" ~ uniqid();
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

        excerpt = [];
        if (file && line) {
            excerpt = Debugger.excerpt(file, line, 1);
        }
        code = join("\n", excerpt);

        return <<<HTML
<div class="cake-error">
    {toggle}: {description} [in <b>{somePath}</b>, line <b>{line}</b>]
    <div id="{ anId}-trace" class="cake-stack-trace" style="display: none;">
        {codeToggle}
        <pre id="{ anId}-code" class="cake-code-dump" style="display: none;">{code}</pre>
        <pre class="cake-trace">{trace}</pre>
    </div>
</div>
HTML;
    }
    
    /**
     * Render a toggle link in the error content.
     * Params:
     * string atext The text to insert. Assumed to be HTML safe.
     * @param string aid The error id scope.
     * @param string asuffix The element selector.
     * /
    private string renderToggle(string atext, string aid, string asuffix) {
        selector =  anId ~ "-" ~ suffix;

        
        return <<<HTML
<a href="javascript:void(0);"
  onclick="document.getElementById("{selector}").style.display = (document.getElementById("{selector}").style.display == "none' ? "" : 'none")"
>
    {text}
</a>
HTML;
        
    } */ 
}
