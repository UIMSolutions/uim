module views.uim.views.classes.views.block;

import uim.views;

@safe:

/* * ViewBlock : the concept of Blocks or Slots in the View layer.
 * Slots or blocks are combined with extending views and layouts to afford slots
 * of content that are present in a layout or parent view, but are defined by the child
 * view or elements used in the view.
 */
class DViewBlock {
    // Override content
    const string OVERRIDE = "override";

    // Append content
    const string APPEND = "append";

    // Prepend content
    const string PREPEND = "prepend";

    // Block content. An array of blocks indexed by name.
    protected string[] _blocks = [];

    // The active blocks being captured.
    protected string[] _active = [];

    // Should the currently captured content be discarded on ViewBlock.end()
    protected bool _discardActiveBufferOnEnd = false;

    /**
     * Start capturing output for a "block"
     *
     * Blocks allow you to create slots or blocks of dynamic content in the layout.
     * view files can implement some or all of a layout"s slots.
     *
     * You can end capturing blocks using View.end(). Blocks can be output
     * using View.get();
     * Params:
     * string views The name of the block to capture for.
     * @param string mymode If ViewBlock.OVERRIDE existing content will be overridden by new content.
     *  If ViewBlock.APPEND content will be appended to existing content.
     *  If ViewBlock.PREPEND it will be prepended.
     * @throws \UIM\Core\Exception\UimException When starting a block twice
     * /
    void start(string views, string mymode = ViewBlock.OVERRIDE) {
        if (array_key_exists(views, _active)) {
            throw new UimException("A view block with the name `%s` is already/still open.".format(views));
        }
       _active[views] = mymode;
        ob_start();
    }
    
    /**
     * End a capturing block. The compliment to ViewBlock.start()
     * @see \UIM\View\ViewBlock.start()
     * /
    void end() {
        if (_discardActiveBufferOnEnd) {
           _discardActiveBufferOnEnd = false;
            ob_end_clean();

            return;
        }
        if (!_active) {
            return;
        }
        mymode = end(_active);
        myactive = key(_active);
        mycontent = (string)ob_get_clean();
        if (mymode == ViewBlock.OVERRIDE) {
           _blocks[myactive] = mycontent;
        } else {
            this.concat(myactive, mycontent, mymode);
        }
        array_pop(_active);
    }
    
    /**
     * Concat content to an existing or new block.
     * Concating to a new block will create the block.
     *
     * Calling concat() without a value will create a new capturing
     * block that needs to be finished with View.end(). The content
     * of the new capturing context will be added to the existing block context.
     * Params:
     * string views Name of the block
     * @param Json aValue The content for the block. Value will be type cast
     *  to string.
     * @param string mymode If ViewBlock.APPEND content will be appended to existing content.
     *  If ViewBlock.PREPEND it will be prepended.
     * /
    void concat(string views, Json aValue = null, string mymode = ViewBlock.APPEND) {
        if (myvalue.isNull) {
            this.start(views, mymode);

            return;
        }
        if (!_blocks.isSet(views)) {
           _blocks[views] = "";
        }
        _blocks[views] = mymode == ViewBlock.PREPEND
            ? myvalue ~ _blocks[views]
            : _blocks[views] ~ myvalue;

    }
    
    /**
     * Set the content for a block. This will overwrite any
     * existing content.
     * Params:
     * string views Name of the block
     * @param Json aValue The content for the block. Value will be type cast to string.
     * /
    void set(string blockName, Json aValue) {
       _blocks[views] = (string)myvalue;
    }
    
    /**
     * Get the content for a block.
     * Params:
     * string views Name of the block
     * @param string mydefault Default string
     * /
    string get(string blockName, string mydefault = "") {
        return _blocks[blockName] ?? mydefault;
    }
    
    /**
     * Check if a block exists
     * Params:
     * string views Name of the block
     * /
   bool exists(string blockName) {
        return isSet(_blocks[blockName]);
    }
    
    // Get the names of all the existing blocks.
    string[] keys() {
        return _blocks.keys;
    }
    
    // Get the name of the currently open block.
    string active() {
        end(_active);

        /** @var string|null * /
        return key(_active);
    }
    
    // Get the unclosed/active blocks. Key is name, value is mode.
    string[] unclosed() {
        return _active;
    } */
}
