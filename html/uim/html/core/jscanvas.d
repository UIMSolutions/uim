module uim.html.core.jscanvas;

@safe:
import uim.html;

//class DJSCanvas : DJS {
//	string idName;
//	string contextName = "context";
//
//	this(string name) { super(); idName = name; }
//	this(DJS aListener, string name, bool inABlock = false) { super(aListener, inABlock); idName = name; }
//
//	override string toString() {
//		auto j = new DJS;
//		return j.Var("canvas", `document.getElementById('%s')`.format(idName))
//			.If("canvas", 
//				`var %s = canvas.getContext('2d');
//			if (%s) { 
//				%s
//			}`.format(contextName, contextName, super.toString)
//				).toString;
//	}	
//
//	// Canvas Functions
//	@property auto Font(string name) { add(contextName~".font = %s;".format(name)); return this; }
//
//	auto FillRect(string x, string y, string w, string h) { add(contextName~".fillRect(%s, %s, %s, %s);".format(x, y, w, h)); return this; }
//	auto FillRect(double x, double y, double w, double h) { add(contextName~".fillRect(%s, %s, %s, %s);".format(x, y, w, h)); return this; }
//
//	/* fillStyle
//	 * Setter or Getter for color, gradient, or pattern used to fill a drawing.
//	 * Default: 	#000000
//	 * Syntax: 	context.fillStyle=color|gradient|pattern;
//	 */
//	@property auto FillStyle(string style) {
//		add(contextName~".fillStyle = %s;".format(style));
//		return this;
//	}
//	@property auto ShadowColor(string color) {
//		add(contextName~".shadowColor = %s;".format(color));
//		return this;
//	}
//	auto ClearRect(double x, double y, double w, double h) {
//		add(contextName~".clearRect(%s, %s, %s, %s);".format(x, y, w, h));
//		return this;
//	}
//	@property auto StrokeStyle(string style) {
//		add(contextName~".strokeStyle = %s;".format(style));
//		return this;
//	}
//
//	auto StrokeRect(string x, string y, string w, string h) { add(contextName~".strokeRect(%s, %s, %s, %s);".format(x, y, w, h)); return this; }
//	auto StrokeRect(double x, double y, double w, double h) { add(contextName~".strokeRect(%s, %s, %s, %s);".format(x, y, w, h)); return this; }
//
//	auto BeginPath() {
//		add(contextName~".beginPath();"); return this;
//	}
//	auto MoveTo(double x, double y) { 
//		add(contextName~".moveTo(%s, %s);".format(x, y)); return this;
//	}
//	auto LineTo(double x, double y) { 
//		add(contextName~".lineTo(%s, %s);".format(x, y)); return this;
//	}
//	auto ClosePath() {
//		add(contextName~".closePath();"); return this;
//	}
//	auto Stroke() {
//		add(contextName~".stroke();"); return this;
//	}
//	auto Fill() {
//		add(contextName~".fill();"); return this;
//	}
//	auto Arc(double x, double y, double w, double h, double r, bool b) { 
//		add(contextName~".arc(%s, %s, %s, %s, %s, %s);".format(x, y, w, h, r, b ? "true" : "false")); return this;
//	}
//	auto BezierCurveTo(double x, double y, double w, double h, double r, double b) { 
//		add(contextName~".bezierCurveTo(%s, %s, %s, %s, %s, %s);".format(x, y, w, h, r, b)); return this;
//	}
//	auto QuadraticCurveTo(double x, double y, double w, double h) { 
//		add(contextName~".quadraticCurveTo(%s, %s, %s, %s);".format(x, y, w, h)); return this;
//	}
//
//	@property auto LineWidth() { add(contextName~".lineWidth;"); return this; }
//	@property auto LineWidth(double value) { add(contextName~".lineWidth = %s;".format(value)); return this; }
//	@property auto LineWidth(string value) { add(contextName~".lineWidth = %s;".format(value)); return this; }
//
//	@property auto LineCap() { add(contextName~".lineCap"); return this; }
//	@property auto LineCap(string value) { add(contextName~".lineCap = %s;".format(value)); return this; }
//
//	@property auto LineJoin(string value) { add(contextName~".lineJoin = %s;".format(value)); return this; }
//
//	@property auto ShadowBlur() { add(contextName~".shadowBlur"); return this; }
//	@property auto ShadowBlur(double value) { add(contextName~".shadowBlur = %s;".format(value)); return this; }
//	@property auto ShadowBlur(string value) { add(contextName~".shadowBlur = %s;".format(value)); return this; }
//
//	@property auto ShadowOffsetY() { add(contextName~".shadowOffsetY"); return this; }
//	@property auto ShadowOffsetY(double value) { add(contextName~".shadowOffsetY = %s;".format(value)); return this; }
//	@property auto ShadowOffsetY(string value) { add(contextName~".shadowOffsetY = %s;".format(value)); return this; }
//
//	@property auto ShadowOffsetX() { add(contextName~".shadowOffsetX"); return this; }
//	@property auto ShadowOffsetX(double value) { add(contextName~".shadowOffsetX = %s;".format(value)); return this; }
//	@property auto ShadowOffsetX(string value) { add(contextName~".shadowOffsetX = %s;".format(value)); return this; }
//
//	auto StrokeText(string text, string x, string y) { 
//		add(contextName~".strokeText(%s, %s, %s);".format(text, x, y)); return this;
//	}
//
//	//Dispatcher
//	override public DJS call(string mName) {
//		switch(mName) {
//			case "BeginPath": return BeginPath(); 
//			case "ClosePath": return ClosePath(); 
//			case "Stroke": return Stroke(); 
//			case "Fill": return Fill(); 
//			default: break;
//		}
//		return super.call(mName);
//	}
//	override public DJS call(string mName, string value) {
//		switch(mName) {
//			case "Font": return Font(value); 
//			case "FillStyle": return FillStyle(value); 
//			case "StrokeStyle": return StrokeStyle(value); 
//			case "LineCap": return LineCap(value); 
//			case "LineJoin": return LineJoin(value); 
//			case "LineWidth": return LineWidth(value); 
//			default: break;
//		}
//		return super.call(mName, value);
//	}
//	override public DJS call(string mName, double value) {
//		switch(mName) {
//			case "LineWidth": return LineWidth(value); 
//			default: break;
//		}
//		return super.call(mName, value);
//	}
//
//	override DJS call(string mName, double[] values...) { 
//		if (values.length == 4) {
//			switch(mName) {
//				case "FillRect": return FillRect(values[0], values[1], values[2], values[3]); 
//				case "StrokeRect": return StrokeRect(values[0], values[1], values[2], values[3]);
//				default: break;
//			}
//		}
//		return super.call(mName, values);
//	}
//	override DJS call(string mName, string[] values...) { 
//		switch(values.length) {
//			case 3: 
//				switch(mName) {
//					case "StrokeText": return StrokeText(values[0], values[1], values[2]); 
//					default: break;
//				} break;
//			case 4: 
//				switch(mName) {
//					case "FillRect": return FillRect(values[0], values[1], values[2], values[3]); 
//					case "StrokeRect": return StrokeRect(values[0], values[1], values[2], values[3]);
//					default: break;
//				} break;
//			default: break;
//		}
//		return super.call(mName, values);
//	}
//}
//mixin(Shortcut!("DJSCanvas", "JSCanvas", "name", "string name"));

version(test_uim_html) { unittest {
		// TODO Add Test
		}}