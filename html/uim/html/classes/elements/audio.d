/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.classes.elements.audio;

import uim.html;

@safe:

// The <audio> tag defines sound, such as music or other audio streams.
class DH5Audio : DH5Obj {
  mixin(H5This!"Audio");

  // Attribute autoplay - if specified, the audio will automatically begin playback as soon as it can do so, without waiting for the entire audio file to finish downloading.
  mixin(MyAttribute!"autoplay");

  // Attribute controls - If this attribute is present, the browser will offer controls to allow the user to control audio playback, including volume, seeking, and pause/resume playback.
  mixin(MyAttribute!"controls");

  // Attribute crossorigin - This enumerated attribute indicates whether to use CORS to fetch the related audio file.
  // Valid values: anonymous use-credentials
  mixin(MyAttribute!"crossorigin");

  // Attribute disableremoteplayback - A Boolean attribute used to disable the capability of remote playback in devices that are attached using wired (HDMI, DVI, etc.) and wireless technologies (Miracast, Chromecast, DLNA, AirPlay, etc).
  mixin(MyAttribute!"disableremoteplayback");

  // Attribute loop - if specified, the audio player will automatically seek back to the start upon reaching the end of the audio.
  mixin(MyAttribute!"loop");

  // Attribute muted - indicates whether the audio will be initially silenced.
  mixin(MyAttribute!"muted");

  // Attribute preload - This enumerated attribute is intended to provide a hint to the browser about what the author thinks will lead to the best user experience.
  mixin(MyAttribute!"preload"); // Valid values: none, metadata, auto

  // Attribute preload - The URL of the audio to embed. 
  mixin(MyAttribute!"src");

  mixin(MyContent!("source", "H5Source"));
  mixin(MyContent!("track", "H5Track"));
}

mixin(H5Short!"Audio");

version (test_uim_html) {
  unittest {
    testH5Obj(H5Audio, "audio");
    assert(H5Audio.source(["src": "horse.ogg", "type": "audio/ogg"]) == `<audio><source src="horse.ogg" type="audio/ogg"></source></audio>`);
    assert(H5Audio.source(["src": "horse.ogg", "type": "audio/ogg"])("Your browser does not support the audio tag.") == `<audio><source src="horse.ogg" type="audio/ogg"></source>Your browser does not support the audio tag.</audio>`);

    mixin(TestH5DoubleAttributes!("H5Audio", "audio", [
          "autoplay", "buffered", "controls", "crossorigin",
          "disableremoteplayback", "loop", "muted", "preload", "src"
        ]));
  }
}
