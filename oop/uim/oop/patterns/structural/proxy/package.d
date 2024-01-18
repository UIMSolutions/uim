/*********************************************************************************************************
*  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.structural.proxy;

import uim.oop;
@safe:

/// Create an interface.
 interface Image {
   void display();
}

/// Create concrete classes implementing the same interface.
 class RealImage : Image {

   private string fileName;

    this(string fileName) {
      this.fileName = fileName;
      loadFromDisk(fileName);
   }

   override  void display() {
      writeln("Displaying "~fileName);
   }

   private void loadFromDisk(string fileName) {
      writeln("Loading "~fileName);
   }
}

 class ProxyImage : Image{

   private RealImage realImage;
   private string fileName;

    this(string fileName) {
      this.fileName = fileName;
   }

   override  void display() {
      if(realImage.isNull) {
         realImage = new RealImage(fileName);
      }
      realImage.display();
   }
}

bool isNull(RealImage aImage) {
   return aImage is null;
}

/// Use the ProxyImage to get object of RealImage class when required.
version(test_uim_oop) { unittest {
      writeln("ProxyPatternDemo");
      
      Image image = new ProxyImage("test_10mb.jpg");

      //image will be loaded from disk
      image.display(); 
      writeln("");
      
      //image will not be loaded from disk
      image.display(); 	
   }
}