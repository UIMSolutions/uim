/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.renderers.html.error;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

/*
 * Interactive HTML error rendering with a stack trace.
 *
 * Default output renderer for non CLI SAPI.
 */
class DHtmlErrorRenderer : DErrorRenderer {
    mixin(ErrorRendererThis!("Html"));

    // Output to stdout which is the server response.
    override void write(string outputText) {
        writeln(outputText);
    }

    override string render(IError error, bool shouldDebug) {
        if (!shouldDebug) {
            return null;
        }
        /* string anId = "uimErr" ~ uniqid();
        auto file = error.file(); */

        /*
        // Some of the error data is not HTML safe so we escape everything.
        Json description = htmlAttributeEscape(error.message());
        Json somePath = htmlAttributeEscape(file);
        Json trace = htmlAttributeEscape(error.getTraceAsString());
        auto line = error.line();

        string errorMessage = "<b>%s</b> (%s)"
            .format(h(capitalize(error.label())), htmlAttributeEscape(error.code())
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
HTML; */
        return null;
    }

    // Render a toggle link in the error content.
    private string renderToggle(string textToInsert, string errorId, string elementSelector) {
        /* string selector = errorId ~ "-" ~ elementSelector;

        return `<<<HTML
<a href="javascript:void(0);"
  onclick="document.getElementById("{selector}").style.display = (document.getElementById("{selector}").style.display == "none' ? "" : 'none")"
>
    {textToInsert}
</a>
HTML`; */
        return null;

    }
}
mixin(ErrorRendererCalls!("Html"));

unittest {
  assert(HtmlErrorRenderer);
}
