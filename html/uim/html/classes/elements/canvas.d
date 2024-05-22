module uim.html.classes.elements.canvas;

import std.stdio;
import std.conv;
import std.string;

import uim.html;

@safe:
class DH5Canvas : DH5Obj {
	string pre = "context.";
	mixin(H5This!"canvas");

	this(string id, int width, int height, string style = "") { 
		super("canvas"); 
		this.attributes(["id":id, "width":to!string(width), "height":to!string(height), "style": style]); /* clean; */ }

	// AddColorStop() 	Specifies the colors and stop positions in a gradient object
	auto addColorStop(this O)(string varName, string stop, string color) { 
		this.js(varName~".addColorStop("~stop~","~color~");"); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).addColorStop("name", "0", "black"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');name.addColorStop(0,black);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// Arc() 	Creates an arc/curve (used to create circles, or parts of circles)
	auto arc(this O)(int x, int y, int r, int sAngle, int eAngle, bool b = false) { this.js(pre~"arc(%s,%s,%s,%s,%s,%s);".format(x, y, r, sAngle, eAngle, b ? "true" : "false")); return cast(O)this; }
	auto arc(this O)(string x, string y, string r, string sAngle, string eAngle, bool b = false) { this.js(pre~"arc(%s,%s,%s,%s,%s,%s);".format(x, y, r, sAngle, eAngle, b ? "true" : "false")); return cast(O)this; }

	// ArcTo() 	Creates an arc/curve between two tangents
	auto arcTo(this O)(int x1, int y1, int x2, int y2, int r) { this.js(pre~"arcTo(%s,%s,%s,%s,%s);".format(x1, y1, x2, y2, r)); return cast(O)this; }
	auto arcTo(this O)(string x1, string y1, string x2, string y2, string r) { this.js(pre~"arcTo(%s,%s,%s,%s,%s);".format(x1, y1, x2, y2, r)); return cast(O)this; }

	// beginPath() 	Begins a path, or resets the current path
	auto beginPath(this O)() { this.js(pre~"beginPath();"); return cast(O)this; }

	// BezierCurveTo() 	Creates a cubic Bézier curve
	auto bezierCurveTo(this O)(int cpx0, int cpy0, int cpx1, int cpy1, int x, int  y) { this.js(pre~"bezierCurveTo(%s,%s,%s,%s,%s,%s);".format(cpx0, cpy0, cpx1, cpy1, x, y)); return cast(O)this; }
	auto bezierCurveTo(this O)(string cpx0, string cpy0, string cpx1, string cpy1, string x, string  y) { this.js(pre~"bezierCurveTo(%s,%s,%s,%s,%s,%s);".format(cpx0, cpy0, cpx1, cpy1, x, y)); return cast(O)this; }

	//	clearRect 	Sets or returns the color, gradient, or pattern used to stroke the drawing
	auto clearRect(this O)(int x, int y, int width, int height) { this.js(pre~"clearRect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }
	auto clearRect(this O)(string x, string y, string width, string height) { this.js(pre~"clearRect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).clearRect("0","0","10","10"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.clearRect(0,0,10,10);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// Clip() 	Clips a region of any shape and size from the original canvas
	auto clip(this O)() { this.js(pre~"clip();"); return cast(O)this; }

	// ClosePath() 	Creates a path from the current point back to the starting point
 	auto closePath(this O)() { this.js(pre~"closePath();"); return cast(O)this; }

	// CreateImageData() 	Creates a new, blank ImageData object
	auto createImageData(this O)(double width, double height) { this.js(pre~"createImageData(%s,%s)".format(width, height));  return cast(O)this; }
	auto createImageData(this O)(string width, string height) { this.js(pre~"createImageData(%s,%s)".format(width, height)); return cast(O)this; }
	auto createImageData(this O)(string image) { this.js(pre~"createImageData(%s)".format(image)); return cast(O)this; }

	// CreateLinearGradient() 	Creates a linear gradient (to use on canvas content)
	auto createLinearGradient(this O)(string varName, int x0, int y0, int x1, int y1) { 
		this.js("var %s=context.createLinearGradient(%s,%s,%s,%s);".format(varName, x0, y0, x1, y1)); return cast(O)this; }
	auto createLinearGradient(this O)(string varName, string x0, string y0, string x1, string y1) { 
		this.js("var %s=context.createLinearGradient(%s,%s,%s,%s);".format(varName, x0, y0, x1, y1)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).createLinearGradient("name", "0", "0", "10", "10"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');var name=context.createLinearGradient(0,0,10,10);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// CreatePattern() 	Repeats a specified element in the specified direction
	auto createPattern(this O)(string varName,string image,string mode) { 
		this.js("var %s=context.createPattern(%s,%s);".format(varName, image, mode)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).createPattern("name", "image", "mode"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');var name=context.createPattern(image,mode);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// CreateRadialGradient() 	Creates a radial/circular gradient (to use on canvas content)
	auto createRadialGradient(this O)(string varName, int x0, int y0, int r0, int x1, int y1, int r1) { 
		this.js("var %s=context.createRadialGradient(%s,%s,%s,%s,%s,%s);".format(varName, x0, y0, r0, x1, y1, r1)); return cast(O)this; }
	auto createRadialGradient(this O)(string varName, string x0, string y0, string r0, string x1, string y1, string r1) { 
		this.js("var %s=context.createRadialGradient(%s,%s,%s,%s,%s,%s);".format(varName, x0, y0, r0, x1, y1, r1)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).createRadialGradient("name", "0", "0", "5", "10", "10", "100"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');var name=context.createRadialGradient(0,0,5,10,10,100);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// ----- Image Drawing
	// DrawImage() 	Draws an image, canvas, or video onto the canvas
	auto drawImage(this O)(string image, double x, double y) { this.js(pre~"drawImage(%s,%s,%s);".format(image, x, y)); return cast(O)this; }
	auto drawImage(this O)(string image, string x, string y) { this.js(pre~"drawImage(%s,%s,%s);".format(image, x, y)); return cast(O)this; }
	auto drawImage(this O)(string image, double x, double y, double width, double height) { this.js(pre~"drawImage(%s,%s,%s,%s,%s);".format(image, x, y, width, height)); return cast(O)this; }
	auto drawImage(this O)(string image, string x, string y, string width, string height) { this.js(pre~"drawImage(%s,%s,%s,%s,%s);".format(image, x, y, width, height)); return cast(O)this; }
	auto drawImage(this O)(string image, double sx, double sy, double sWidth, double sHeight, double x, double y, double width, double height) { this.js(pre~"drawImage(%s,%s,%s,%s,%s,%s,%s,%s,%s);".format(image, sx, sy, sWidth, sHeight, x, y, width, height)); return cast(O)this; }

	// Fill() 	Fills the current drawing (path)
 	auto fill(this O)() { this.js(pre~"fill();"); return cast(O)this; }

	//	FillRect 	Sets or returns the color, gradient, or pattern used to fill the drawing
	auto fillRect(this O)(int x, int y, int width, int height) { this.js(pre~"fillRect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }
	auto fillRect(this O)(string x, string y, string width, string height) { this.js(pre~"fillRect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).fillRect("0","0","10","10"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.fillRect(0,0,10,10);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// FillStyle 	Sets or returns the color, gradient, or pattern used to fill the drawing
	auto fillStyle(this O)(string style) { this.js(pre~"fillStyle="~style~";"); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).fillStyle("value"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.fillStyle=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}
	// FillText() 	Draws "filled" text on the canvas
	auto fillText(this O)(string text, double x, double y) { this.js(pre~"fillText(%s,%s,%s);".format(text, x, y)); return cast(O)this; }
	auto fillText(this O)(string text, double x, double y, double maxWidth) { this.js(pre~"fillText(%s,%s,%s,%s);".format(text, x, y, maxWidth)); return cast(O)this; }
	auto fillText(this O)(string text, string x, string y) { this.js(pre~"fillText(%s,%s,%s);".format(text, x, y)); return cast(O)this; }
	auto fillText(this O)(string text, string x, string y, string maxWidth) { this.js(pre~"fillText(%s,%s,%s,%s);".format(text, x, y, maxWidth)); return cast(O)this; }

	// Font 	Sets or returns the current font properties for text content
	auto font(this O)(string value) { this.js(pre~"font("~value~");"); return cast(O)this; }

	// GetImageData() 	Returns an ImageData object that copies the pixel data for the specified rectangle on a canvas
	auto getImageData(this O)(double x, double y, double width, double height) { this.js(pre~"getImageData(%s,%s,%s,%s)".format(x, y, width, height)); return this; }
	auto getImageData(this O)(string x, string y, string width, string height) { this.js(pre~"getImageData(%s,%s,%s,%s)".format(x, y, width, height)); return this; }

	// GlobalAlpha 	Sets or returns the current alpha or transparency value of the drawing
	auto globalAlpha(this O)(double number) { this.js(pre~"globalAlpha(%s);".format(number)); return cast(O)this; }
	auto globalAlpha(this O)(string number) { this.js(pre~"globalAlpha(%s);".format(number)); return cast(O)this; }

	// globalCompositeOperation 	Sets or returns how a new image are drawn onto an existing image
	enum CompositeOperations : string {
		SourceOver = "source-over", // 	Default. Displays the source image over the destination image 	
		SourceATop = "source-atop", // 	Displays the source image on top of the destination image. The part of the source image that is outside the destination image is not shown 	
		SourceIn = "source-in", // 	Displays the source image in to the destination image. Only the part of the source image that is INSIDE the destination image is shown, and the destination image is transparent 	
		SourceOut = "source-out", // 	Displays the source image out of the destination image. Only the part of the source image that is OUTSIDE the destination image is shown, and the destination image is transparent 	
		DestinationOver = "destination-over", // 	Displays the destination image over the source image 	
		DestinationATop = "destination-atop", // 	Displays the destination image on top of the source image. The part of the destination image that is outside the source image is not shown 	
		DestinationIn = "destination-in", // 	Displays the destination image in to the source image. Only the part of the destination image that is INSIDE the source image is shown, and the source image is transparent 	
		DestinationOut = "destination-out", // 	Displays the destination image out of the source image. Only the part of the destination image that is OUTSIDE the source image is shown, and the source image is transparent 	
		Lighter = "lighter", // 	Displays the source image + the destination image 	
		Copy = "copy", // 	Displays the source image. The destination image is ignored 	
		Xor = "xor" // 	The source image is combined by using an exclusive OR with the destination image
	}
	auto globalCompositeOperation(this O)(CompositeOperations operation) { this.js(pre~"globalCompositeOperation='%s';".format(operation)); return cast(O)this; }
	auto globalCompositeOperation(this O)(string operation) { this.js(pre~"globalCompositeOperation=%s;".format(operation)); return cast(O)this; }

	// IsPointInPath() 	Returns true if the specified point is in the current path, otherwise false
	auto isPointInPath(this O)(double x, double y) { this.js(pre~"isPointInPath(%s,%s);".format(x, y)); return cast(O)this; }
	auto isPointInPath(this O)(string x, string y) { this.js(pre~"isPointInPath(%s,%s);".format(x, y)); return cast(O)this; }

	// LineCap - Sets the style of the end caps for a line
	// valid values are butt, round, square
	auto lineCap(this O)(string value) { this.js(pre~"lineCap=%s;".format(value)); return cast(O)this; }

	// LineJoin 	Sets the type of corner created, when two lines meet
	auto lineJoin(this O)(string value) { this.js(pre~"lineJoin=%s;".format(value)); return cast(O)this; }

	// LineTo() 	Adds a new point and creates a line from that point to the last specified point in the canvas (x, y)
	auto lineTo(this O)(int x, int y) { this.js(pre~"lineTo(%s,%s);".format(x, y)); return cast(O)this; }
	auto lineTo(this O)(string x, string y) { this.js(pre~"lineTo(%s,%s);".format(x, y)); return cast(O)this; }

	//	lineWidth 	Sets the current line width
	auto lineWidth(this O)(uint value) { this.js(pre~"lineWidth=%s;".format(value)); return cast(O)this; }
	auto lineWidth(this O)(string value) { this.js(pre~"lineWidth=%s;".format(value)); return cast(O)this; }

	//	// MiterLimit 	Sets or returns the maximum miter length
	auto miterLimit(this O)(uint length) { this.js(pre~"miterLimit=%s;".format(length)); return cast(O)this; }
	auto miterLimit(this O)(string length) { this.js(pre~"miterLimit=%s;".format(length)); return cast(O)this; }

	// measureText() 	Moves the path to the specified point in the canvas, without creating a line
	auto measureText(this O)(string varName, string text) { this.js(("%s="~pre~"measureText(%s).width;").format(varName, text)); return cast(O)this; }

	// MoveTo() 	Moves the path to the specified point in the canvas, without creating a line
	auto moveTo(this O)(int x, int y) { this.js(pre~"moveTo(%s,%s);".format(x, y)); return cast(O)this; }
	auto moveTo(this O)(string x, string y) { this.js(pre~"moveTo(%s,%s);".format(x, y)); return cast(O)this; }

	// PutImageData() 	Puts the image data (from a specified ImageData object) back onto the canvas
	auto putImageData(this O)(string image, double x, double y) { this.js(pre~"putImageData(%s,%s,%s);".format(image, x, y)); return cast(O)this; }
	auto putImageData(this O)(string image, string x, string y) { this.js(pre~"putImageData(%s,%s,%s);".format(image, x, y)); return cast(O)this; }
	auto putImageData(this O)(string image, double x, double y, double dirtyX, double dirtyY, double dirtyWidth, double dirtyHeight) { this.js(pre~"putImageData(%s,%s,%s,%s,%s,%s,%s);".format(image, x, y, dirtyX, dirtyY, dirtyWidth, dirtyHeight)); return cast(O)this; }
	auto putImageData(this O)(string image, string x, string y, string dirtyX, string dirtyY, string dirtyWidth, string dirtyHeight) { this.js(pre~"putImageData(%s,%s,%s,%s,%s,%s,%s);".format(image, x, y, dirtyX, dirtyY, dirtyWidth, dirtyHeight)); return cast(O)this; }

	// QuadraticCurveTo() 	Creates a quadratic Bézier curve
	auto quadraticCurveTo(this O)(int cpx, int cpy, int x, int y) { this.js(pre~"quadraticCurveTo(%s,%s,%s,%s);".format(cpx, cpy, x, y)); return cast(O)this; }
	auto quadraticCurveTo(this O)(string cpx, string cpy, string x, string y) { this.js(pre~"quadraticCurveTo(%s,%s,%s,%s);".format(cpx, cpy, x, y)); return cast(O)this; }

	//	Rect() 	Creates a rectangle
	auto rect(this O)(int x, int y, int width, int height) { this.js(pre~"rect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }
	auto rect(this O)(string x, int y, int width, int height) { this.js(pre~"rect(%s,%s,%s,%s);".format(x, y, width, height)); return cast(O)this; }

	// Restore() 	Returns previously saved path state and attributes
	auto restore(this O)() { this.js(pre~"restore();"); return cast(O)this; }

	// Rotate() 	Rotate	s the current drawing
	auto rotate(this O)(double angle) { this.js(pre~"rotate(%s);".format(angle)); return cast(O)this; }
	auto rotate(this O)(string angle) { this.js(pre~"rotate(%s);".format(angle)); return cast(O)this; }

	// Save() 	Saves the state of the current context
	auto save(this O)() { this.js(pre~"save();"); return cast(O)this; }

	// Scale() 	Scales the current drawing bigger or smaller
	auto scale(this O)(double scaleWidth, double scaleHeight) { this.js(pre~"scale(%s,%s);".format(scaleWidth, scaleHeight)); return cast(O)this; }
	auto scale(this O)(string scaleWidth, string scaleHeight) { this.js(pre~"scale(%s,%s);".format(scaleWidth, scaleHeight)); return cast(O)this; }

	// ShadowBlur 	Sets or returns the blur level for shadows
	auto shadowBlur(this O)(uint blur) { this.js(pre~"shadowBlur=%s;".format(blur)); return cast(O)this; }
	auto shadowBlur(this O)(string blur) { this.js(pre~"shadowBlur=%s;".format(blur)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).shadowBlur("value"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.shadowBlur=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// ShadowColor 	Sets or returns the color to use for shadows
	// auto shadowColor(this O)() { add(pre~"shadowColor"); return this; }
	auto shadowColor(this O)(string color) { this.js(pre~"shadowColor=%s;".format(color)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).shadowColor("value"),  `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.shadowColor=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// ShadowOffsetX 	Sets the horizontal distance of the shadow from the shape
	auto shadowOffsetX(this O)(int value) { this.js(pre~"shadowOffsetX=%s;".format(value)); return cast(O)this; }
	auto shadowOffsetX(this O)(string value) { this.js(pre~"shadowOffsetX=%s;".format(value)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).shadowOffsetX("value"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.shadowOffsetX=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// ShadowOffsetY 	Sets the vertical distance of the shadow from the shape
	auto shadowOffsetY(this O)(int value) { this.js(pre~"shadowOffsetY=%s;".format(value)); return cast(O)this; }
	auto shadowOffsetY(this O)(string value) { this.js(pre~"shadowOffsetY=%s;".format(value)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).shadowOffsetY("value"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.shadowOffsetY=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// SetTransform() 	Resets the current transform to the identity matrix. Then runs transform()
auto setTransform(this O)(double a, double b, double c, double d, double e, double f) { this.js(pre~"setTransform(%s,%s,%s,%s,%s,%s);".format(a, b, c, d, e, f)); return cast(O)this; }
auto setTransform(this O)(string a, string b, string c, string d, string e, string f) { this.js(pre~"setTransform(%s,%s,%s,%s,%s,%s);".format(a, b, c, d, e, f)); return cast(O)this; }

	// Stroke() 	Actually draws the path you have defined
	auto stroke(this O)() { this.js(pre~"stroke();"); return cast(O)this; }

	//	StrokeRect 	Sets or returns the color, gradient, or pattern used to stroke the drawing
	auto strokeRect(this O)(int x, int y, int width, int height) { this.js(pre~"strokeRect(%s,%s,%s,%s);".format(x,y,width,height)); return cast(O)this;	}
	auto strokeRect(this O)(string x, string y, string width, string height) { this.js(pre~"strokeRect(%s,%s,%s,%s);".format(x,y,width,height)); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).strokeRect("0","0","10","10"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.strokeRect(0,0,10,10);}window.addEventListener("load",drawtest,true);</script>`));
*/	}}
	//	StrokeStyle 	Sets or returns the color, gradient, or pattern used for strokes
	auto strokeStyle(this O)(string style) { this.js(pre~"strokeStyle="~style~";"); return cast(O)this; }
	version(test_uim_html) { unittest {
/*		assert(H5Canvas("test", [""]).strokeStyle("value"), `<canvas id="test"></canvas><script>function drawtest(){var canvas=document.getElementById('test');`~
		`var context=canvas.getContext('2d');context.strokeStyle=value;}window.addEventListener("load",drawtest,true);</script>`));
*/	}}

	// StrokeText() 	Draws text on the canvas (no fill)
	auto strokeText(this O)(string text, double x, double y) { this.js(pre~"strokeText(%s,%s,%s);".format(text, x, y)); return cast(O)this; }
	auto strokeText(this O)(string text, string x, string y) { this.js(pre~"strokeText(%s,%s,%s);".format(text, x, y)); return cast(O)this; }
	auto strokeText(this O)(string text, double x, double y, double maxWidth) { this.js(pre~"strokeText(%s,%s,%s,%s);".format(text, x, y, maxWidth)); return cast(O)this; }
	auto strokeText(this O)(string text, string x, string y, string maxWidth) { this.js(pre~"strokeText(%s,%s,%s,%s);".format(text, x, y, maxWidth)); return cast(O)this; }

	// TextAlign 	Sets or returns the current alignment for text content
	enum TextAligns : string { 
		Start = "start", // Default. The text starts at the specified position
		End = "end", // The text ends at the specified position 
		Center = "center", // The center of the text is placed at the specified position 	
		Left = "left", // The text starts at the specified position 	
		Right = "right" // The text ends at the specified position 
	}
	auto textAlign(this O)(TextAligns anAlign) { this.js(pre~"textAlign='%s';".format(anAlign)); return cast(O)this; }
	auto textAlign(this O)(string anAlign) { this.js(pre~"textAlign=%s;".format(anAlign)); return cast(O)this; }

	// TextBaseline 	Sets or returns the current text baseline used when drawing text
	enum TextBaselines : string { 
		ALphabetic = "alphabetic", // Default. The text baseline is the normal alphabetic baseline 
		Top = "top", // The text baseline is the top of the em square 
		Hanging = "hanging", // The text baseline is the hanging baseline 
		Middle = "middle", // 	The text baseline is the middle of the em square 
		Ideographic = "ideographic", // The text baseline is the ideographic baseline 
		Bottom = "bottom" // The text baseline is the bottom of the bounding box
	}
	auto textBaseline(this O)(TextBaselines aBaseline) { this.js(pre~"textBaseline = '%s';".format(aBaseline)); return cast(O)this; }
	auto textBaseline(this O)(string aBaseline) { this.js(pre~"textBaseline = '%s';".format(aBaseline)); return cast(O)this; }

	// Translate() 	Remaps the (0,0) position on the canvas
	auto translate(this O)(double x, double y) { this.js(pre~"translate(%s,%s);".format(x, y)); return cast(O)this; }
	auto translate(this O)(string x, string y) { this.js(pre~"translate(%s,%s);".format(x, y)); return cast(O)this; }

	// Transform() 	Replaces the current transformation matrix for the drawing
	auto transform(this O)(double a, double b, double c, double d, double e, double f) { this.js(pre~"transform(%s,%s,%s,%s,%s,%s);".format(a, b, c, d, e, f)); return cast(O)this; }
	auto transform(this O)(string a, string b, string c, string d, string e, string f) { this.js(pre~"transform(%s,%s,%s,%s,%s,%s);".format(a, b, c, d, e, f)); return cast(O)this; }

	override string toString() {
		if (_id.empty) _id="canvas"~to!string(uniform(0, 1_000_000));
		auto drawFunc = `draw`~_id;
		_js = `function `~drawFunc~`(){var canvas=document.getElementById('`~_id~`');`~
		`var context=canvas.getContext('2d');`~_js~`}window.addEventListener("load",`~drawFunc~`,true);`;
		return super.toString;
	}
}
mixin(H5Short!"Canvas");
auto H5Canvas(string id, int width, int height, string style = "") { 
	return new DH5Canvas(id, width, height, style); 
}
