/*********************************************************************************************************
  Copyright: © 2015 -2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.patterns.structural.adapters;

import uim.oop;
@safe:

/// Create interfaces for Media Player and Advanced Media Player.
 interface MediaPlayer {
    void play(string audioType, string fileName);
}

 interface AdvancedMediaPlayer {	
    void playVlc(string fileName);
    void playMp4(string fileName);
}

/// Create concrete classes implementing the AdvancedMediaPlayer interface.
 class VlcPlayer : AdvancedMediaPlayer{
   override  void playVlc(string fileName) {
      writeln("Playing vlc file. Name: ", fileName);		
   }

   override  void playMp4(string fileName) {
      //do nothing
   }
}

 class Mp4Player : AdvancedMediaPlayer{

   override  void playVlc(string fileName) {
      //do nothing
   }

   override  void playMp4(string fileName) {
      writeln("Playing mp4 file. Name: ", fileName);		
   }
}

/// Create adapter class implementing the MediaPlayer interface.
 class MediaAdapter : MediaPlayer {

   AdvancedMediaPlayer advancedMusicPlayer;

    this(string audioType) {
   
      if(audioType.toLower == "vlc") {
         advancedMusicPlayer = new VlcPlayer();			
         
      } else if (audioType.toLower == "mp4") {
         advancedMusicPlayer = new Mp4Player();
      }	
   }

  override void play(string audioType, string fileName) {
    switch(audioType.toLower) {
      case "vlc": 
        advancedMusicPlayer.playVlc(fileName);
        break;
      case "mp4": 
        advancedMusicPlayer.playMp4(fileName);
        break;
      default: break;
    }
  }
}

/// Create concrete class implementing the MediaPlayer interface
 class AudioPlayer : MediaPlayer {
   MediaAdapter mediaAdapter; 

   override void play(string audioType, string fileName) {		
      //inbuilt support to play mp3 music files
      if(audioType.toLower == "mp3") {
         writeln("Playing mp3 file. Name: ", fileName);			
      } 
      
      //mediaAdapter is providing support to play other file formats
      else if(audioType.toLower == "vlc" || audioType.toLower == "mp4") {
         mediaAdapter = new MediaAdapter(audioType);
         mediaAdapter.play(audioType, fileName);
      }
      
      else{
         writeln("Invalid media. ", audioType, " format not supported");
      }
   }   
}

/// Use the AudioPlayer to play different types of audio formats.
version(test_uim_oop) { unittest {
    writeln("AdapterPatternDemo"); 
    AudioPlayer audioPlayer = new AudioPlayer();

    audioPlayer.play("mp3", "beyond the horizon.mp3");
    audioPlayer.play("mp4", "alone.mp4");
    audioPlayer.play("vlc", "far far away.vlc");
    audioPlayer.play("avi", "mind me.avi");
  }
}
