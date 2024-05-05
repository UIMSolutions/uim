module uim.commands.helpers.progress;

import uim.commands;

@safe:

/**
 * Create a progress bar using a supplied callback.
 *
 * ## Usage
 *
 * The ProgressHelper can be accessed from shells using the helper() method
 *
 * ```
 * this.helper("Progress").output(["callback": auto (progress) {
 *    // Do work
 *    progress.increment();
 * });
 * ```
 */
class DProgressHelper { // } : Helper {
      mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

  /**
     * Default value for progress bar total value.
     * Percent completion is derived from progress/total
     */
  protected const DEFAULT_TOTAL = 100;

  // Default value for progress bar width
  protected const DEFAULT_WIDTH = 80;

  // The current progress.
  protected float _progress = 0;

  // The total number of 'items' to progress through.
  protected int _total = DEFAULT_TOTAL;

  // The width of the bar.
  protected int _width = DEFAULT_WIDTH;

  /**
     * Output a progress bar.
     *
     * Takes a number of options to customize the behavior:
     *
     * - `total` The total number of items in the progress bar. Defaults
     *  to 100.
     * - `width` The width of the progress bar. Defaults to 80.
     * - `callback` The callback that will be called in a loop to advance the progress bar.
     * Params:
     * array commandArguments The arguments/options to use when outputing the progress bar.
     * /
  void output(Json[string] commandArguments) {
    commandArguments ~= ["callback": null];
    if (isSet(commandArguments[0])) {
      commandArguments["callback"] = commandArguments[0];
    }
    if (!commandArguments["callback"] || !isCallable(commandArguments["callback"])) {
      throw new DInvalidArgumentException("Callback option must be a callable.");
    }
    this.initialize(commandArguments);

    aCallback = commandArguments["callback"];

    _io.out ("", 0);
    while (_progress < _total) {
      aCallback(this);
      this.draw();
    }
    _io.out ("");
  }

  /**
     * Initialize the progress bar for use.
     *
     * - `total` The total number of items in the progress bar. Defaults
     *  to 100.
     * - `width` The width of the progress bar. Defaults to 80.
     * Params:
     * array commandArguments The initialization data.

     * /
  bool initialize(Json[string] commandArguments = []) {
    commandArguments += ["total": self: : DEFAULT_TOTAL, "width": self: : DEFAULT_WIDTH];
    _progress = 0;
    _width = commandArguments["width"];
    _total = commandArguments["total"];
  }

  /**
     * Increment the progress bar.
     * Params:
     * float|int num The amount of progress to advance by.
     * /
  void increment(float | int num = 1) {
    _progress = min(max(0, _progress + num), _total);
  }

  // Render the progress bar based on the current state.
  void draw() {
    size_t numberLength = " 100%".length;
    auto complete = round(_progress / _total, 2);
    auto barLen = (_width - numberLength)*_progress / _total;
    
    string myBar = "";
    if (barLen > 1) {
      myBar = str_repeat("=", to!int(barLen - 1))~">";
    }
    pad = ceil(_width - numberLength - barLen);
    if (pad > 0) {
      myBar ~= str_repeat(" ", (int)pad);
    }
    percent = (complete * 100)~"%";
    myBar ~= str_pad(percent, numberLength, " ", STR_PAD_LEFT);

    _io.overwrite(myBar, 0);
  } */
}
