module uim.html.classes.elements;

import uim.html.classes.core; 

public import uim.html.classes.elements.mixins;

public import uim.html.classes.elements.a;
public import uim.html.classes.elements.abbr;
public import uim.html.classes.elements.address;
public import uim.html.classes.elements.area;
public import uim.html.classes.elements.article;
public import uim.html.classes.elements.aside;
public import uim.html.classes.elements.audio;
public import uim.html.classes.elements.b;
public import uim.html.classes.elements.base;
public import uim.html.classes.elements.bdi;
public import uim.html.classes.elements.bdo;
public import uim.html.classes.elements.blockquote;
public import uim.html.classes.elements.body_;
public import uim.html.classes.elements.br;
public import uim.html.classes.elements.button;
public import uim.html.classes.elements.canvas;
public import uim.html.classes.elements.caption; 
public import uim.html.classes.elements.cite;
public import uim.html.classes.elements.code;
public import uim.html.classes.elements.col;
public import uim.html.classes.elements.colgroup;
public import uim.html.classes.elements.comment;
public import uim.html.classes.elements.content;
public import uim.html.classes.elements.data;
public import uim.html.classes.elements.datalist;
public import uim.html.classes.elements.dd;
public import uim.html.classes.elements.del;
public import uim.html.classes.elements.details;
public import uim.html.classes.elements.dfn;
public import uim.html.classes.elements.dialog;
public import uim.html.classes.elements.div;
public import uim.html.classes.elements.dl;
public import uim.html.classes.elements.dt;
public import uim.html.classes.elements.element;
public import uim.html.classes.elements.em;
public import uim.html.classes.elements.embed;
public import uim.html.classes.elements.fieldset;
public import uim.html.classes.elements.figcaption;
public import uim.html.classes.elements.figure;
public import uim.html.classes.elements.footer;
public import uim.html.classes.elements.form;
public import uim.html.classes.elements.h;
public import uim.html.classes.elements.head;
public import uim.html.classes.elements.header;
public import uim.html.classes.elements.hr;
public import uim.html.classes.elements.html;
public import uim.html.classes.elements.i;
public import uim.html.classes.elements.iframe;
public import uim.html.classes.elements.img;
public import uim.html.classes.elements.input;
public import uim.html.classes.elements.inputs;
public import uim.html.classes.elements.ins;
public import uim.html.classes.elements.kbd;
public import uim.html.classes.elements.label;
public import uim.html.classes.elements.legend;
public import uim.html.classes.elements.li;
public import uim.html.classes.elements.link;
public import uim.html.classes.elements.main_;
public import uim.html.classes.elements.map;
public import uim.html.classes.elements.mark;
public import uim.html.classes.elements.math;
public import uim.html.classes.elements.menu;
public import uim.html.classes.elements.meta;
public import uim.html.classes.elements.meter;
public import uim.html.classes.elements.nav;
public import uim.html.classes.elements.noscript;
public import uim.html.classes.elements.object;
public import uim.html.classes.elements.ol;
public import uim.html.classes.elements.optgroup;
public import uim.html.classes.elements.option;
public import uim.html.classes.elements.output;
public import uim.html.classes.elements.p;
public import uim.html.classes.elements.param;
public import uim.html.classes.elements.picture;
public import uim.html.classes.elements.pre;
public import uim.html.classes.elements.progress;
public import uim.html.classes.elements.q;
public import uim.html.classes.elements.rbc;
public import uim.html.classes.elements.rp;
public import uim.html.classes.elements.rt;
public import uim.html.classes.elements.rtc;
public import uim.html.classes.elements.ruby;
public import uim.html.classes.elements.s;
public import uim.html.classes.elements.samp;
public import uim.html.classes.elements.script;
public import uim.html.classes.elements.section;
public import uim.html.classes.elements.select;
public import uim.html.classes.elements.slot;
public import uim.html.classes.elements.small;
public import uim.html.classes.elements.source;
public import uim.html.classes.elements.span;
public import uim.html.classes.elements.strong;
public import uim.html.classes.elements.style;
public import uim.html.classes.elements.sub;
public import uim.html.classes.elements.summary;
public import uim.html.classes.elements.sup;
public import uim.html.classes.elements.svg;
public import uim.html.classes.elements.table;
public import uim.html.classes.elements.tbody;
public import uim.html.classes.elements.td;
public import uim.html.classes.elements.textarea;
public import uim.html.classes.elements.template_;
public import uim.html.classes.elements.tfoot;
public import uim.html.classes.elements.th;
public import uim.html.classes.elements.thead;
public import uim.html.classes.elements.time;
public import uim.html.classes.elements.title;
public import uim.html.classes.elements.tr;
public import uim.html.classes.elements.track;
public import uim.html.classes.elements.u;
public import uim.html.classes.elements.ul;
public import uim.html.classes.elements.var;
public import uim.html.classes.elements.video;
public import uim.html.classes.elements.wbr;

enum HTML = "HTML";
enum HEAD = "HEAD";
enum BODY = "BODY";
enum LINK = "LINK";
enum Script = "Script";
enum Div = "Div";
enum A = "A";
enum BIG = "BIG";
enum TITLE = "TITLE";
enum META = "META";
enum STYLE = "STYLE";
enum BASE = "BASE";
enum HEADER = "HEADER";
enum NAV = "NAV";
enum ASIDE = "ASIDE";
enum ADDRESS = "ADDRESS";
enum MAIN = "MAIN";
enum SECTION = "SECTION";
enum ARTICLE = "ARTICLE";
enum FOOTER = "FOOTER";
enum H1 = "H1"; 
enum H2 = "H2"; 
enum H3 = "H3"; 
enum H4 = "H4"; 
enum P = "P";
enum PRE = "PRE";
enum BLOCKQUOTE = "BLOCKQUOTE";
enum FIGURE = "FIGURE";
enum FIGCAPTION = "FIGCAPTION";
enum OL = "OL";
enum UL = "UL";
enum DL = "DL";
enum LI = "LI";
enum DT = "DT";
enum DD = "DD";
enum HR = "HR";
enum B = "B";
enum EM = "EM";
enum I = "I";
enum KBD = "KBD";
enum MARK = "MARK";
enum S = "S";
enum SMALL = "SMALL";
enum STRONG = "STRONG";
enum SUB = "SUB";
enum SUP = "SUP";
enum U = "U";
enum CITE = "CITE";
enum Q = "Q";
enum DFN = "DFN";
enum ABBR = "ABBR";
enum CODE = "CODE";
enum VAR = "VAR";
enum SAMP = "SAMP";
enum TIME = "TIME";
enum RUBY = "RUBY";
enum RT = "RT";
enum RP = "RP";
enum BDI = "BDI";
enum BDO = "BDO";
enum BR = "BR";
enum WBR = "WBR";
enum DEL = "DEL";
enum INS = "INS";
enum SPAN = "SPAN";
enum TABLE = "TABLE";
enum CAPTION = "CAPTION";
enum COL = "COL";
enum COLGROUP = "COLGROUP";
enum THEAD = "THEAD";
enum TBODY = "TBODY";
enum TFOOT = "TFOOT";
enum TR = "TR";
enum TH = "TH";
enum TD = "TD";
enum MAP = "MAP";
enum AREA = "AREA";
enum IMG = "IMG";
enum PICTURE = "PICTURE";
enum CANVAS = "CANVAS";
enum SVG = "SVG";
enum MATH = "MATH";
enum IFRAME = "IFRAME";
enum EMBED = "EMBED";
enum OBJECT = "OBJECT";
enum PARAM = "PARAM";
enum AUDIO = "AUDIO";
enum VIDEO = "VIDEO";
enum SOURCE = "SOURCE";
enum TRACK = "TRACK";
enum FORM = "FORM";
enum FIELDSET = "FIELDSET";
enum LEGEND = "LEGEND";
enum LABEL = "LABEL";
enum DATALIST = "DATALIST";
enum INPUT = "INPUT";
enum Button = "Button";
enum SELECT = "SELECT";
enum OPTGROUP = "OPTGROUP";
enum OPTION = "OPTION";
enum TEXTAREA = "TEXTAREA";
enum KEYGEN = "KEYGEN";
enum OUTPUT = "OUTPUT";
enum PROGRESS = "PROGRESS";
enum METER = "METER";
enum NOScript = "NOScript";
enum CONTENT = "CONTENT";
enum DECORATOR = "DECORATOR";
enum ELEMENT = "ELEMENT";
enum SHADOW = "SHADOW";
enum TEMPLATE = "TEMPLATE";
enum DETAILS = "DETAILS";
enum SUMMARY = "SUMMARY";
enum DIALOG = "DIALOG";
enum MENU = "MENU";
enum MENUITEM = "MENUITEM";
enum COMMAND = "COMMAND";

/*
class DH5 {
	// Grundstruktur
	static auto HTML() { return new DH5HTML(); }
	static auto HEAD() { return new DH5HEAD(); }
	static auto BODY() { return new DH5BODY(); }

	// Kopfdaten
	static auto TITLE() { return new DH5TITLE(); }
	static auto META() { return new DH5META(); }
	static auto LINK() { return new DH5LINK(); }
	static auto STYLE() { return new DH5STYLE(); }
	static auto BASE() { return new DH5BASE(); }

	// Seitenstrukturierung
	static auto HEADER() { return new DH5HEADER(); }
	static auto NAV() { return new DH5NAV(); }
	static auto ASIDE() { return new DH5ASIDE(); }
	static auto MAIN() { return new DH5MAIN(); }
	static auto SECTION() { return new DH5SECTION(); }
	static auto ARTICLE() { return new DH5ARTICLE(); }
	static auto ADDRESS() { return new DH5ADDRESS(); }
	static auto FOOTER() { return new DH5FOOTER(); }
	static auto H1() { return new DH5H1; }
	static auto H2() { return new DH5H2; }
	static auto H3() { return new DH5H3; }
	static auto H4() { return new DH5H4; }
	static auto H5() { return new DH5H5; }
	static auto H6() { return new DH5H6; }

	// Textstrukturierung
	static auto P() { return new DH5P(); }
	static auto PRE() { return new DH5PRE(); }
	static auto BLOCKQUOTE() { return new DH5BLOCKQUOTE(); }
	static auto FIGCAPTION() { return new DH5FIGCAPTION(); }
	static auto FIGURE() { return new DH5FIGURE(); }
	static auto OL() { return new DH5OL(); }
	static auto UL() { return new DH5UL(); }
	static auto DL() { return new DH5DL(); }
	static auto LI() { return new DH5LI(); }
	static auto DT() { return new DH5DT(); }
	static auto DD() { return new DH5DD(); }
	static auto HR() { return new DH5HR(); }
	static auto Div() { return new DH5Div(); }
	
	// Textauszeichnung			
	static auto B() { return new DH5B(); }
	static auto EM() { return new DH5EM(); }
	static auto I() { return new DH5I(); }
	static auto KBD() { return new DH5KBD(); }
	static auto MARK() { return new DH5MARK(); }
	static auto S() { return new DH5S(); }
	static auto SMALL() { return new DH5SMALL(); }
	static auto STRONG() { return new DH5STRONG(); }
	static auto SUB() { return new DH5SUB(); }
	static auto SUP() { return new DH5SUP(); }
	static auto U() { return new DH5U(); }
	static auto CITE() { return new DH5CITE(); }
	static auto Q() { return new DH5Q(); }
	static auto DFN() { return new DH5DFN(); }
	//	static auto ABBR() { return new DH5ABBR(); }
	static auto CODE() { return new DH5CODE(); }
	static auto VAR() { return new DH5VAR(); }
	static auto SAMP() { return new DH5SAMP(); }
	static auto TIME() { return new DH5TIME(); }
	static auto RUBY() { return new DH5RUBY(); }
	static auto RT() { return new DH5RT(); }
	static auto RP() { return new DH5RP(); }
	static auto BDI() { return new DH5BDI(); }
	static auto BDO() { return new DH5BDO(); }
	static auto BR() { return new DH5BR(); }
	static auto WBR() { return new DH5WBR(); }
	static auto DEL() { return new DH5DEL(); }
	static auto INS() { return new DH5INS(); }
	static auto SPAN() { return new DH5SPAN(); }

	// Tabellen
	static auto TABLE() { return new DH5TABLE(); }
	static auto CAPTION() { return new DH5CAPTION(); }
	static auto COL() { return new DH5COL(); }
	static auto COLGROUP() { return new DH5COLGROUP(); }
	static auto THEAD() { return new DH5THEAD(); }
	static auto TBODY() { return new DH5TBODY(); }
	static auto TFOOT() { return new DH5TFOOT(); }
	static auto TR() { return new DH5TR(); }
	static auto TH() { return new DH5TH(); }
	static auto TD() { return new DH5TD(); }
	
	// Links (Verweise)
	//	static auto A() { return new DH5A(); }
	static auto MAP() { return new DH5MAP(); }
	static auto AREA() { return new DH5AREA(); }
	
	// Multimedia und Grafiken
	static auto IMG() { return new DH5IMG(); }
	static auto PICTURE() { return new DH5PICTURE(); }
	static auto CANVAS() { return new DH5CANVAS(); }
	static auto SVG() { return new DH5SVG(); }
	static auto MATH() { return new DH5MATH(); }
	static auto IFRAME() { return new DH5IFRAME(); }
	static auto EMBED() { return new DH5EMBED(); }
	static auto OBJECT() { return new DH5OBJECT(); }
	static auto PARAM() { return new DH5PARAM(); }
	static auto AUDIO() { return new DH5AUDIO(); }
	static auto VIDEO() { return new DH5VIDEO(); }
	static auto SOURCE() { return new DH5SOURCE(); }
	static auto TRACK() { return new DH5TRACK(); }
	
	// Formulare
	static auto FORM() { return new DH5FORM(); }
	static auto FIELDSET() { return new DH5FIELDSET(); }
	static auto LEGEND() { return new DH5LEGEND(); }
	static auto LABEL() { return new DH5LABEL(); }
	static auto DATALIST() { return new DH5DATALIST(); }
	static auto INPUT() { return new DH5INPUT(); }
	static auto Button() { return new DH5Button(); }
	static auto SELECT() { return new DH5SELECT(); }
	static auto OPTGROUP() { return new DH5OPTGROUP(); }
	static auto OPTION() { return new DH5OPTION(); }
	static auto TEXTAREA() { return new DH5TEXTAREA(); }
	static auto KEYGEN() { return new DH5KEYGEN(); }
	static auto OUTPUT() { return new DH5OUTPUT(); }
	static auto PROGRESS() { return new DH5PROGRESS(); }
	static auto METER() { return new DH5METER(); }

	// Skripte
	static auto Script() { return new DH5Script(); }
	static auto NOScript() { return new DH5NOScript(); }
	static auto CONTENT() { return new DH5CONTENT(); }
	static auto DECORATOR() { return new DH5DECORATOR(); }
	//	static auto ELEMENT() { return new DH5ELEMENT(); }
	static auto SHADOW() { return new DH5SHADOW(); }
	// static auto TEMPLATE() { return new DH5TEMPLATE(); }
	
	// Interaktive Elemente
	static auto DETAILS() { return new DH5DETAILS(); }
	static auto SUMMARY() { return new DH5SUMMARY(); }
	static auto DIALOG() { return new DH5DIALOG(); }
	static auto MENU() { return new DH5MENU(); }
	static auto MENUITEM() { return new DH5MENUITEM(); }
	static auto COMMAND() { return new DH5COMMAND(); }

	//static auto opCall(string val) { 
	//	switch(val) {
	//		case "HTML": return new DH5HTML();
	//		case "HEAD": return new DH5HEAD();
	//		case "BODY": return new DH5BODY();
	//		case "TITLE": return new DH5TITLE();
	//		case "META": return new DH5META();
	//		case "LINK": return new DH5LINK();
	//		case "STYLE": return new DH5STYLE();
	//		case "BASE": return new DH5BASE();
	//		case "HEADER": return new DH5HEADER();
	//		case "NAV": return new DH5NAV();
	//		case "ASIDE": return new DH5ASIDE();
	//		case "MAIN": return new DH5MAIN();
	//		case "SECTION": return new DH5SECTION();
	//		case "ARTICLE": return new DH5ARTICLE();
	//		case "ADDRESS": return new DH5ADDRESS();
	//		case "FOOTER": return new DH5FOOTER();
	//		case "BIG": return new DH5BIG();
	//		case "H1": return new DH5H1;
	//		case "H2": return new DH5H2;
	//		case "H3": return new DH5H3;
	//		case "H4": return new DH5H4;
	//		case "H5": return new DH5H5;
	//		case "H6": return new DH5H6;
	//		case "P": return new DH5P();
	//		case "PRE": return new DH5PRE();
	//		case "BLOCKQUOTE": return new DH5BLOCKQUOTE();
	//		case "FIGCAPTION": return new DH5FIGCAPTION();
	//		case "FIGURE": return new DH5FIGURE();
	//		case "OL": return new DH5OL();
	//		case "UL": return new DH5UL();
	//		case "DL": return new DH5DL();
	//		case "LI": return new DH5LI();
	//		case "DT": return new DH5DT();
	//		case "DD": return new DH5DD();
	//		case "HR": return new DH5HR();
	//		case "Div": return new DH5Div();
	//		case "B": return new DH5B();
	//		case "EM": return new DH5EM();
	//		case "I": return new DH5I();
	//		case "KBD": return new DH5KBD();
	//		case "MARK": return new DH5MARK();
	//		case "S": return new DH5S();
	//		case "SMALL": return new DH5SMALL();
	//		case "STRONG": return new DH5STRONG();
	//		case "SUB": return new DH5SUB();
	//		case "SUP": return new DH5SUP();
	//		case "U": return new DH5U();
	//		case "CITE": return new DH5CITE();
	//		case "Q": return new DH5Q();
	//		case "DFN": return new DH5DFN();
	//			//			case "ABBR": return new DH5ABBR();
	//		case "CODE": return new DH5CODE();
	//		case "VAR": return new DH5VAR();
	//		case "SAMP": return new DH5SAMP();
	//		case "TIME": return new DH5TIME();
	//		case "RUBY": return new DH5RUBY();
	//		case "RT": return new DH5RT();
	//		case "RP": return new DH5RP();
	//		case "BDI": return new DH5BDI();
	//		case "BDO": return new DH5BDO();
	//		case "BR": return new DH5BR();
	//		case "WBR": return new DH5WBR();
	//		case "DEL": return new DH5DEL();
	//		case "INS": return new DH5INS();
	//		case "SPAN": return new DH5SPAN();
	//		case "TABLE": return new DH5TABLE();
	//		case "CAPTION": return new DH5CAPTION();
	//		case "COL": return new DH5COL();
	//		case "COLGROUP": return new DH5COLGROUP();
	//		case "THEAD": return new DH5THEAD();
	//		case "TBODY": return new DH5TBODY();
	//		case "TFOOT": return new DH5TFOOT();
	//		case "TR": return new DH5TR();
	//		case "TH": return new DH5TH();
	//		case "TD": return new DH5TD();
	//						case "A": return new DH5A();
	//		case "MAP": return new DH5MAP();
	//		case "AREA": return new DH5AREA();
	//		case "IMG": return new DH5IMG();
	//		case "PICTURE": return new DH5PICTURE();
	//		case "CANVAS": return new DH5CANVAS();
	//		case "SVG": return new DH5SVG();
	//		case "MATH": return new DH5MATH();
	//		case "IFRAME": return new DH5IFRAME();
	//		case "EMBED": return new DH5EMBED();
	//		case "OBJECT": return new DH5ElementECT();
	//		case "PARAM": return new DH5PARAM();
	//		case "AUDIO": return new DH5AUDIO();
	//		case "VIDEO": return new DH5VIDEO();
	//		case "SOURCE": return new DH5SOURCE();
	//		case "TRACK": return new DH5TRACK();
	//		case "FORM": return new DH5FORM();
	//		case "FIELDSET": return new DH5FIELDSET();
	//		case "LEGEND": return new DH5LEGEND();
	//		case "LABEL": return new DH5LABEL();
	//		case "DATALIST": return new DH5DATALIST();
	//		case "INPUT": return new DH5INPUT();
	//		case "Button": return new DH5Button();
	//		case "SELECT": return new DH5SELECT();
	//		case "OPTGROUP": return new DH5OPTGROUP();
	//		case "OPTION": return new DH5OPTION();
	//		case "TEXTAREA": return new DH5TEXTAREA();
	//		case "KEYGEN": return new DH5KEYGEN();
	//		case "OUTPUT": return new DH5OUTPUT();
	//		case "PROGRESS": return new DH5PROGRESS();
	//		case "METER": return new DH5METER();
	//		case "Script": return new DH5Script();
	//		case "NOScript": return new DH5NOScript();
	//		case "CONTENT": return new DH5CONTENT();
	//		case "DECORATOR": return new DH5DECORATOR();
	//			//			case "ELEMENT": return new DH5ELEMENT();
	//		case "SHADOW": return new DH5SHADOW();
	//		case "TEMPLATE": return new DH5TEMPLATE();
	//		case "DETAILS": return new DH5DETAILS();
	//		case "SUMMARY": return new DH5SUMMARY();
	//		case "DIALOG": return new DH5DIALOG();
	//		case "MENU": return new DH5MENU();
	//		case "MENUITEM": return new DH5MENUITEM();
	//		case "COMMAND": return new DH5COMMAND();
	//		default: return null;
	//	}
	//	}			
	//	static DH5Root opCall(string val, STRINGAA atts) { 
	//		auto h5 = H5(val);
	//		h5.attributes = atts;
	//		return h5;
	//	}			
	//	static DH5Root opCall(string val, string[] texts...) { 
	//		auto h5 = H5(val);
	//		h5 << texts;
	//		return h5;
	//	}			
}
// template H5(string name) { mixin("DH5"~name~" h5 = new DH5"~name~"();"); }

//auto H5()() { return new DH5Root(); }
//auto H5(string name)() { return DH5(name); }
//auto H5(string name)(STRINGAA attributes) { return DH5(name).add(attributes); }
//auto H5(string name)(DObject[]  elements...) { return DH5(name).add(elements); }
//auto H5(string name)(string[] texts...) { return DH5(name).add(texts); }
//auto H5(string name)(STRINGAA attributes, DObject[]  elements...) { return DH5(name).add(attributes).add(elements); }
//auto H5(string name)(STRINGAA attributes, string[] texts...) { return DH5(name).add(attributes).add(texts); }

// Extras

//string H5(string predicate)(string content = "") {
//	string result;
//	
//	foreach (number; numbers) {
//		if (mixin (predicate)) {
//			result ~= number;
//		}
//	}
//	
//	return result;
//}


//auto H5()() { return new DH5Root(); }
//auto H5(string name)() { return DH5(name); }
//auto H5(string name)(STRINGAA attributes) { return DH5(name).add(attributes); }
//auto H5(string name)(DObject[]  elements...) { return DH5(name).add(elements); }
//auto H5(string name)(string[] texts...) { return DH5(name).add(texts); }
//auto H5(string name)(STRINGAA attributes, DObject[]  elements...) { return DH5(name).add(attributes).add(elements); }
//auto H5(string name)(STRINGAA attributes, string[] texts...) { return DH5(name).add(attributes).add(texts); }
*/

/**
 * module uim.html;

 import std.stdio;
 import std.string;

 /*
 class 
 All classes | Properties | Methods
 Inheritance	
 Subclasses	yii\bootstrap\BaseHtml, yii\bootstrap\Html, yii\helpers\Html
 Available since version	2.0
 Source Code	https://github.com/yiisoft/yii2/blob/master/framework/helpers/BaseHtml.php
 BaseHtml provides concrete implementation for yii\helpers\Html.

 Do not use BaseHtml. Use yii\helpers\Html instead.

 Public Properties
 Hide inherited properties

 Property	Type	Description	Defined By
 attributeOrder	array	The preferred order of attributes in a tag.	
 dataAttributes	array	List of tag attributes that should be specially handled when their values are of array type.	
 voidElements	array	List of void elements (element name => 1)	
 */ 
// Public Methods

// Generates a hyperlink tag.	
//string a(string text, string url = null, STRINGAA options = null) {
//	if (!url) {
//		// options['href'] = Url::to(url);
//	}
//	return dtag("a", text, options);
//}
/* 
 activeCheckbox()	Generates a checkbox tag together with a label for the given model attribute.	
 activeCheckboxList()	Generates a list of checkboxes.	
 activeDropDownList()	Generates a drop-down list for the given model attribute.	
 activeFileInput()	Generates a file input tag for the given model attribute.	
 activeHiddenInput()	Generates a hidden input tag for the given model attribute.	
 activeHint()	Generates a hint tag for the given model attribute.	
 activeInput()	Generates an input tag for the given model attribute.	
 activeLabel()	Generates a label tag for the given model attribute.	
 activeListBox()	Generates a list box.	
 activePasswordInput()	Generates a password input tag for the given model attribute.	
 activeRadio()	Generates a radio button tag together with a label for the given model attribute.	
 activeRadioList()	Generates a list of radio buttons.	
 activeTextInput()	Generates a text input tag for the given model attribute.	
 activeTextarea()	Generates a textarea tag for the given model attribute.	
 addCssclass()	Adds a CSS class (or several classes) to the specified options.	
 addCssStyle()	Adds the specified CSS style to the HTML options.	
 beginForm()	Generates a form start tag.	
 beginTag()	Generates a start tag.	
 button()	Generates a button tag.	
 buttonInput()	Generates an input button.	
 checkbox()	Generates a checkbox input.	
 checkboxList()	Generates a list of checkboxes.	
 csrfMetaTags()	Generates the meta tags containing CSRF token information.	
 cssFile()	Generates a link tag that refers to an external CSS file.	
 cssStyleFromArray()	Converts a CSS style array into a string representation.	
 cssStyleToArray()	Converts a CSS style string into an array representation.	
 decode()	Decodes special HTML entities back to the corresponding characters.	
 dropDownList()	Generates a drop-down list.	
 encode()	Encodes special characters into HTML entities.	
 endForm()	Generates a form end tag.	
 endTag()	Generates an end tag.	
 error()	Generates a tag that contains the first validation error of the specified model attribute.	
 errorSummary()	Generates a summary of the validation errors.	
 escapeJsRegularExpression()	Escapes regular expression to use in JavaScript	
 fileInput()	Generates a file input field.	
 getAttributeName()	Returns the real attribute name from the given attribute expression.	
 getAttributeValue()	Returns the value of the specified attribute name or expression.	
 getInputId()	Generates an appropriate input ID for the specified attribute name or expression.	
 getInputName()	Generates an appropriate input name for the specified attribute name or expression.	
 hiddenInput()	Generates a hidden input field.	
 img()	Generates an image tag.	
 input()	Generates an input type of the given type.	
 jsFile()	Generates a script tag that refers to an external JavaScript file.	
 label()	Generates a label tag.	
 listBox()	Generates a list box.	
 mailto()	Generates a mailto hyperlink.	
 ol()	Generates an ordered list.	
 passwordInput()	Generates a password input field.	
 radio()	Generates a radio button input.	
 radioList()	Generates a list of radio buttons.	
 removeCssclass()	Removes a CSS class from the specified options.	
 removeCssStyle()	Removes the specified CSS style from the HTML options.	
 renderSelectOptions()	Renders the option tags that can be used by dropDownList() and listBox().	
 renderTagAttributes()	Renders the HTML tag attributes.	
 resetButton()	Generates a reset button tag.	
 resetInput()	Generates a reset input button.	
 script()	Generates a script tag.	
 style()	Generates a style tag.	
 submitButton()	Generates a submit button tag.	
 submitInput()	Generates a submit input button.	*/
//Generates a complete HTML tag.	

//string toString(STRINGAA kvOptions) {
//	string[] options;
//	foreach(k, v; kvOptions) options ~= "%s=\"%s\"".format(k, v);
//	return options.join(" "); }
//string toString(string[] vOptions) { return vOptions.join(" "); }
//
//string dtag(string name, string content = null, STRINGAA kvOptions = null, string[] vOptions = null) {
//	if (!name) { return content; }
//	
//	string kv; if (kvOptions) kv = " "~kvOptions.toString; 
//	string v;  if (vOptions) v = " "~vOptions.toString; 
//	
//	return "<"~name~kv~v~">"~content~"</"~name~">";
//}
/* textInput()	Generates a text input field.	
 textarea()	Generates a text area input.	
 ul()	Generates an unordered list.	
 Protected Methods
 Hide inherited methods

 Method	Description	Defined By
 activeBooleanInput()	Generates a boolean input This method is mainly called by activeCheckbox() and activeRadio().	
 activeListInput()	Generates a list of input fields.	
 booleanInput()	Generates a boolean input.	
 Property Details
 attributeOrder public static property
 The preferred order of attributes in a tag. This mainly affects the order of the attributes that are rendered by renderTagAttributes().
 public static array attributeOrder = ['type', 'id', 'class', 'name', 'value', 'href', 'src', 'action', 'method', 'selected', 'checked', 'readonly', 'disabled', 'multiple', 'size', 'maxlength', 'width', 'height', 'rows', 'cols', 'alt', 'title', 'rel', 'media']
 dataAttributes public static property (available since version 2.0.3)
 List of tag attributes that should be specially handled when their values are of array type. In particular, if the value of the data attribute is ['name' => 'xyz', 'age' => 13], two attributes will be generated instead of one: data-name="xyz" data-age="13".
 public static array dataAttributes = ['data', 'data-ng', 'ng']
 voidElements public static property
 List of void elements (element name => 1)

 See also http://www.w3.org/TR/html-markup/syntax.html#void-element.
 public static array voidElements = ['area' => 1, 'base' => 1, 'br' => 1, 'col' => 1, 'command' => 1, 'embed' => 1, 'hr' => 1, 'img' => 1, 'input' => 1, 'keygen' => 1, 'link' => 1, 'meta' => 1, 'param' => 1, 'source' => 1, 'track' => 1, 'wbr' => 1]
 Method Details
 a() public static method
 Generates a hyperlink tag.

 See also yii\helpers\Url::to().
 public static string a ( text, url = null, options = [] )
 text	string	
 Link body. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is coming from end users, you should consider encode() it to prevent XSS attacks.
 url	array|string|null	
 The URL for the hyperlink tag. This parameter will be processed by yii\helpers\Url::to() and will be used for the "href" attribute of the tag. If this parameter is null, the "href" attribute will not be generated.
 If you want to use an absolute url you can call yii\helpers\Url::to() yourself, before passing the URL to this method, like this:
 Html::a('link text', Url::to(url, true))
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated hyperlink
 activeBooleanInput() protected static method (available since version 2.0.9)
 Generates a boolean input This method is mainly called by activeCheckbox() and activeRadio().
 protected static string activeBooleanInput ( type, model, attribute, options = [] )
 type	string	
 The input type. This can be either radio or checkbox.
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. See booleanInput() for details about accepted attributes.
 return	string	
 The generated input element
 activeCheckbox() public static method
 Generates a checkbox tag together with a label for the given model attribute.

 This method will generate the "checked" tag attribute according to the model attribute value.
 public static string activeCheckbox ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. See booleanInput() for details about accepted attributes.
 return	string	
 The generated checkbox tag
 activeCheckboxList() public static method
 Generates a list of checkboxes.

 A checkbox list allows multiple selection, like listBox(). As a result, the corresponding submitted value is an array. The selection of the checkbox list is taken from the value of the model attribute.
 public static string activeCheckboxList ( model, attribute, items, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 items	array	
 The data item used to generate the checkboxes. The array keys are the checkbox values, and the array values are the corresponding labels. Note that the labels will NOT be HTML-encoded, while the values will.
 options	array	
 Options (name => config) for the checkbox list container tag. The following options are specially handled:
 tag: string|false, the tag name of the container element. False to render checkbox without container. See also tag().
 unselect: string, the value that should be submitted when none of the checkboxes is selected. You may set this option to be null to prevent default value submission. If this option is not set, an empty string will be submitted.
 encode: boolean, whether to HTML-encode the checkbox labels. Defaults to true. This option is ignored if item option is set.
 separator: string, the HTML code that separates items.
 itemOptions: array, the options for generating the checkbox tag using checkbox().
 item: callable, a callback that can be used to customize the generation of the HTML code corresponding to a single item in items. The signature of this callback must be:
 function (index, label, name, checked, value)
 where index is the zero-based index of the checkbox in the whole list; label is the label for the checkbox; and name, value and checked represent the name, value and the checked status of the checkbox input.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated checkbox list
 activeDropDownList() public static method
 Generates a drop-down list for the given model attribute.

 The selection of the drop-down list is taken from the value of the model attribute.
 public static string activeDropDownList ( model, attribute, items, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 items	array	
 The option data items. The array keys are option values, and the array values are the corresponding option labels. The array can also be nested (i.e. some array values are arrays too). For each sub-array, an option group will be generated whose label is the key associated with the sub-array. If you have a list of data models, you may convert them into the format described above using yii\helpers\ArrayHelper::map().
 Note, the values and labels will be automatically HTML-encoded by this method, and the blank spaces in the labels will also be HTML-encoded.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 prompt: string, a prompt text to be displayed as the first option. Since version 2.0.11 you can use an array to override the value and to set other tag attributes:
 ['text' => 'Please select', 'options' => ['value' => 'none', 'class' => 'prompt', 'label' => 'Select']],
 options: array, the attributes for the select option tags. The array keys must be valid option values, and the array values are the extra attributes for the corresponding option tags. For example,
 [
 'value1' => ['disabled' => true],
 'value2' => ['label' => 'value 2'],
 ];
 groups: array, the attributes for the optgroup tags. The structure of this is similar to that of 'options', except that the array keys represent the optgroup labels specified in items.
 encodeSpaces: bool, whether to encode spaces in option prompt and option value with &nbsp; character. Defaults to false.
 encode: bool, whether to encode option prompt and option value characters. Defaults to true. This option is available since 2.0.3.
 The rest of the options will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated drop-down list tag
 activeFileInput() public static method
 Generates a file input tag for the given model attribute.

 This method will generate the "name" and "value" tag attributes automatically for the model attribute unless they are explicitly specified in options.
 public static string activeFileInput ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated input tag
 activeHiddenInput() public static method
 Generates a hidden input tag for the given model attribute.

 This method will generate the "name" and "value" tag attributes automatically for the model attribute unless they are explicitly specified in options.
 public static string activeHiddenInput ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated input tag
 activeHint() public static method (available since version 2.0.4)
 Generates a hint tag for the given model attribute.

 The hint text is the hint associated with the attribute, obtained via yii\base\Model::getAttributeHint(). If no hint content can be obtained, method will return an empty string.
 public static string activeHint ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. The following options are specially handled:
 hint: this specifies the hint to be displayed. Note that this will NOT be encoded. If this is not set, yii\base\Model::getAttributeHint() will be called to get the hint for display (without encoding).
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated hint tag
 activeInput() public static method
 Generates an input tag for the given model attribute.

 This method will generate the "name" and "value" tag attributes automatically for the model attribute unless they are explicitly specified in options.
 public static string activeInput ( type, model, attribute, options = [] )
 type	string	
 The input type (e.g. 'text', 'password')
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated input tag
 activeLabel() public static method
 Generates a label tag for the given model attribute.

 The label text is the label associated with the attribute, obtained via yii\base\Model::getAttributeLabel().
 public static string activeLabel ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. The following options are specially handled:
 label: this specifies the label to be displayed. Note that this will NOT be encoded. If this is not set, yii\base\Model::getAttributeLabel() will be called to get the label for display (after encoding).
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated label tag
 activeListBox() public static method
 Generates a list box.

 The selection of the list box is taken from the value of the model attribute.
 public static string activeListBox ( model, attribute, items, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 items	array	
 The option data items. The array keys are option values, and the array values are the corresponding option labels. The array can also be nested (i.e. some array values are arrays too). For each sub-array, an option group will be generated whose label is the key associated with the sub-array. If you have a list of data models, you may convert them into the format described above using yii\helpers\ArrayHelper::map().
 Note, the values and labels will be automatically HTML-encoded by this method, and the blank spaces in the labels will also be HTML-encoded.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 prompt: string, a prompt text to be displayed as the first option. Since version 2.0.11 you can use an array to override the value and to set other tag attributes:
 ['text' => 'Please select', 'options' => ['value' => 'none', 'class' => 'prompt', 'label' => 'Select']],
 options: array, the attributes for the select option tags. The array keys must be valid option values, and the array values are the extra attributes for the corresponding option tags. For example,
 [
 'value1' => ['disabled' => true],
 'value2' => ['label' => 'value 2'],
 ];
 groups: array, the attributes for the optgroup tags. The structure of this is similar to that of 'options', except that the array keys represent the optgroup labels specified in items.
 unselect: string, the value that will be submitted when no option is selected. When this attribute is set, a hidden field will be generated so that if no option is selected in multiple mode, we can still obtain the posted unselect value.
 encodeSpaces: bool, whether to encode spaces in option prompt and option value with &nbsp; character. Defaults to false.
 encode: bool, whether to encode option prompt and option value characters. Defaults to true. This option is available since 2.0.3.
 The rest of the options will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated list box tag
 activeListInput() protected static method
 Generates a list of input fields.

 This method is mainly called by activeListBox(), activeRadioList() and activeCheckboxList().
 protected static string activeListInput ( type, model, attribute, items, options = [] )
 type	string	
 The input type. This can be 'listBox', 'radioList', or 'checkBoxList'.
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 items	array	
 The data item used to generate the input fields. The array keys are the input values, and the array values are the corresponding labels. Note that the labels will NOT be HTML-encoded, while the values will.
 options	array	
 Options (name => config) for the input list. The supported special options depend on the input type specified by type.
 return	string	
 The generated input list
 activePasswordInput() public static method
 Generates a password input tag for the given model attribute.

 This method will generate the "name" and "value" tag attributes automatically for the model attribute unless they are explicitly specified in options.
 public static string activePasswordInput ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered. The following special options are recognized:
 maxlength: integer|boolean, when maxlength is set true and the model attribute is validated by a string validator, the maxlength option will take the value of yii\validators\StringValidator::max. This option is available since version 2.0.6.
 return	string	
 The generated input tag
 activeRadio() public static method
 Generates a radio button tag together with a label for the given model attribute.

 This method will generate the "checked" tag attribute according to the model attribute value.
 public static string activeRadio ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. See booleanInput() for details about accepted attributes.
 return	string	
 The generated radio button tag
 activeRadioList() public static method
 Generates a list of radio buttons.

 A radio button list is like a checkbox list, except that it only allows single selection. The selection of the radio buttons is taken from the value of the model attribute.
 public static string activeRadioList ( model, attribute, items, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 items	array	
 The data item used to generate the radio buttons. The array keys are the radio values, and the array values are the corresponding labels. Note that the labels will NOT be HTML-encoded, while the values will.
 options	array	
 Options (name => config) for the radio button list container tag. The following options are specially handled:
 tag: string|false, the tag name of the container element. False to render radio button without container. See also tag().
 unselect: string, the value that should be submitted when none of the radio buttons is selected. You may set this option to be null to prevent default value submission. If this option is not set, an empty string will be submitted.
 encode: boolean, whether to HTML-encode the checkbox labels. Defaults to true. This option is ignored if item option is set.
 separator: string, the HTML code that separates items.
 itemOptions: array, the options for generating the radio button tag using radio().
 item: callable, a callback that can be used to customize the generation of the HTML code corresponding to a single item in items. The signature of this callback must be:
 function (index, label, name, checked, value)
 where index is the zero-based index of the radio button in the whole list; label is the label for the radio button; and name, value and checked represent the name, value and the checked status of the radio button input.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated radio button list
 activeTextInput() public static method
 Generates a text input tag for the given model attribute.

 This method will generate the "name" and "value" tag attributes automatically for the model attribute unless they are explicitly specified in options.
 public static string activeTextInput ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered. The following special options are recognized:
 maxlength: integer|boolean, when maxlength is set true and the model attribute is validated by a string validator, the maxlength option will take the value of yii\validators\StringValidator::max. This is available since version 2.0.3.
 return	string	
 The generated input tag
 activeTextarea() public static method
 Generates a textarea tag for the given model attribute.

 The model attribute value will be used as the content in the textarea.
 public static string activeTextarea ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). See renderTagAttributes() for details on how attributes are being rendered. The following special options are recognized:
 maxlength: integer|boolean, when maxlength is set true and the model attribute is validated by a string validator, the maxlength option will take the value of yii\validators\StringValidator::max. This option is available since version 2.0.6.
 return	string	
 The generated textarea tag
 addCssclass() public static method
 Adds a CSS class (or several classes) to the specified options.

 If the CSS class is already in the options, it will not be added again. If class specification at given options is an array, and some class placed there with the named (string) key, overriding of such key will have no effect. For example:

 options = ['class' => ['persistent' => 'initial']];
 Html::addCssclass(options, ['persistent' => 'override']);
 var_dump(options['class']); // outputs: array('persistent' => 'initial');
 public static void addCssclass ( &options, class )
 options	array	
 The options to be modified.
 class	string|array	
 The CSS class(es) to be added
 addCssStyle() public static method
 Adds the specified CSS style to the HTML options.

 If the options already contain a style element, the new style will be merged with the existing one. If a CSS property exists in both the new and the old styles, the old one may be overwritten if overwrite is true.

 For example,

 Html::addCssStyle(options, 'width: 100px; height: 200px');
 See also:

 removeCssStyle()
 cssStyleFromArray()
 cssStyleToArray()
 public static void addCssStyle ( &options, style, overwrite = true )
 options	array	
 The HTML options to be modified.
 style	string|array	
 The new style string (e.g. 'width: 100px; height: 200px') or array (e.g. ['width' => '100px', 'height' => '200px']).
 overwrite	boolean	
 Whether to overwrite existing CSS properties if the new style contain them too.
 beginForm() public static method
 Generates a form start tag.

 See also endForm().
 public static string beginForm ( action = '', method = 'post', options = [] )
 action	array|string	
 The form action URL. This parameter will be processed by yii\helpers\Url::to().
 method	string	
 The form submission method, such as "post", "get", "put", "delete" (case-insensitive). Since most browsers only support "post" and "get", if other methods are given, they will be simulated using "post", and a hidden input will be added which contains the actual method type. See yii\web\Request::methodParam for more details.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 Special options:
 csrf: whether to generate the CSRF hidden input. Defaults to true.
 return	string	
 The generated form start tag.
 beginTag() public static method
 Generates a start tag.

 See also:

 endTag()
 tag()
 public static string beginTag ( name, options = [] )
 name	string|boolean|null	
 The tag name. If name is null or false, the corresponding content will be rendered without any tag.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated start tag
 booleanInput() protected static method (available since version 2.0.9)
 Generates a boolean input.
 protected static string booleanInput ( type, name, checked = false, options = [] )
 type	string	
 The input type. This can be either radio or checkbox.
 name	string	
 The name attribute.
 checked	boolean	
 Whether the checkbox should be checked.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 uncheck: string, the value associated with the uncheck state of the checkbox. When this attribute is present, a hidden input will be generated so that if the checkbox is not checked and is submitted, the value of this attribute will still be submitted to the server via the hidden input.
 label: string, a label displayed next to the checkbox. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is is coming from end users, you should encode() it to prevent XSS attacks. When this option is specified, the checkbox will be enclosed by a label tag.
 labelOptions: array, the HTML attributes for the label tag. Do not set this option unless you set the "label" option.
 The rest of the options will be rendered as the attributes of the resulting checkbox tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated checkbox tag
 button() public static method
 Generates a button tag.
 public static string button ( content = 'Button', options = [] )
 content	string	
 The content enclosed within the button tag. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is is coming from end users, you should consider encode() it to prevent XSS attacks.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated button tag
 buttonInput() public static method
 Generates an input button.
 public static string buttonInput ( label = 'Button', options = [] )
 label	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated button tag
 checkbox() public static method
 Generates a checkbox input.
 public static string checkbox ( name, checked = false, options = [] )
 name	string	
 The name attribute.
 checked	boolean	
 Whether the checkbox should be checked.
 options	array	
 The tag options in terms of name-value pairs. See booleanInput() for details about accepted attributes.
 return	string	
 The generated checkbox tag
 checkboxList() public static method
 Generates a list of checkboxes.

 A checkbox list allows multiple selection, like listBox(). As a result, the corresponding submitted value is an array.
 public static string checkboxList ( name, selection = null, items = [], options = [] )
 name	string	
 The name attribute of each checkbox.
 selection	string|array|null	
 The selected value(s). String for single or array for multiple selection(s).
 items	array	
 The data item used to generate the checkboxes. The array keys are the checkbox values, while the array values are the corresponding labels.
 options	array	
 Options (name => config) for the checkbox list container tag. The following options are specially handled:
 tag: string|false, the tag name of the container element. False to render checkbox without container. See also tag().
 unselect: string, the value that should be submitted when none of the checkboxes is selected. By setting this option, a hidden input will be generated.
 encode: boolean, whether to HTML-encode the checkbox labels. Defaults to true. This option is ignored if item option is set.
 separator: string, the HTML code that separates items.
 itemOptions: array, the options for generating the checkbox tag using checkbox().
 item: callable, a callback that can be used to customize the generation of the HTML code corresponding to a single item in items. The signature of this callback must be:
 function (index, label, name, checked, value)
 where index is the zero-based index of the checkbox in the whole list; label is the label for the checkbox; and name, value and checked represent the name, value and the checked status of the checkbox input, respectively.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated checkbox list
 csrfMetaTags() public static method
 Generates the meta tags containing CSRF token information.

 See also yii\web\Request::enableCsrfValidation.
 public static string csrfMetaTags ( )
 return	string	
 The generated meta tags
 cssFile() public static method
 Generates a link tag that refers to an external CSS file.

 See also yii\helpers\Url::to().
 public static string cssFile ( url, options = [] )
 url	array|string	
 The URL of the external CSS file. This parameter will be processed by yii\helpers\Url::to().
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 condition: specifies the conditional comments for IE, e.g., lt IE 9. When this is specified, the generated link tag will be enclosed within the conditional comments. This is mainly useful for supporting old versions of IE browsers.
 noscript: if set to true, link tag will be wrapped into <noscript> tags.
 The rest of the options will be rendered as the attributes of the resulting link tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated link tag
 cssStyleFromArray() public static method
 Converts a CSS style array into a string representation.

 For example,

 print_r(Html::cssStyleFromArray(['width' => '100px', 'height' => '200px']));
 // will display: 'width: 100px; height: 200px;'
 public static string cssStyleFromArray ( array style )
 style	array	
 The CSS style array. The array keys are the CSS property names, and the array values are the corresponding CSS property values.
 return	string	
 The CSS style string. If the CSS style is empty, a null will be returned.
 cssStyleToArray() public static method
 Converts a CSS style string into an array representation.

 The array keys are the CSS property names, and the array values are the corresponding CSS property values.

 For example,

 print_r(Html::cssStyleToArray('width: 100px; height: 200px;'));
 // will display: ['width' => '100px', 'height' => '200px']
 public static array cssStyleToArray ( style )
 style	string	
 The CSS style string
 return	array	
 The array representation of the CSS style
 decode() public static method
 Decodes special HTML entities back to the corresponding characters.

 This is the opposite of encode().

 See also:

 encode()
 http://www.php.net/manual/en/function.htmlspecialchars-decode.php
 public static string decode ( content )
 content	string	
 The content to be decoded
 return	string	
 The decoded content
 dropDownList() public static method
 Generates a drop-down list.
 public static string dropDownList ( name, selection = null, items = [], options = [] )
 name	string	
 The input name
 selection	string|array|null	
 The selected value(s). String for single or array for multiple selection(s).
 items	array	
 The option data items. The array keys are option values, and the array values are the corresponding option labels. The array can also be nested (i.e. some array values are arrays too). For each sub-array, an option group will be generated whose label is the key associated with the sub-array. If you have a list of data models, you may convert them into the format described above using yii\helpers\ArrayHelper::map().
 Note, the values and labels will be automatically HTML-encoded by this method, and the blank spaces in the labels will also be HTML-encoded.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 prompt: string, a prompt text to be displayed as the first option. Since version 2.0.11 you can use an array to override the value and to set other tag attributes:
 ['text' => 'Please select', 'options' => ['value' => 'none', 'class' => 'prompt', 'label' => 'Select']],
 options: array, the attributes for the select option tags. The array keys must be valid option values, and the array values are the extra attributes for the corresponding option tags. For example,
 [
 'value1' => ['disabled' => true],
 'value2' => ['label' => 'value 2'],
 ];
 groups: array, the attributes for the optgroup tags. The structure of this is similar to that of 'options', except that the array keys represent the optgroup labels specified in items.
 encodeSpaces: bool, whether to encode spaces in option prompt and option value with &nbsp; character. Defaults to false.
 encode: bool, whether to encode option prompt and option value characters. Defaults to true. This option is available since 2.0.3.
 The rest of the options will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated drop-down list tag
 encode() public static method
 Encodes special characters into HTML entities.

 The application charset will be used for encoding.

 See also:

 decode()
 http://www.php.net/manual/en/function.htmlspecialchars.php
 public static string encode ( content, doubleEncode = true )
 content	string	
 The content to be encoded
 doubleEncode	boolean	
 Whether to encode HTML entities in content. If false, HTML entities in content will not be further encoded.
 return	string	
 The encoded content
 endForm() public static method
 Generates a form end tag.

 See also beginForm().
 public static string endForm ( )
 return	string	
 The generated tag
 endTag() public static method
 Generates an end tag.

 See also:

 beginTag()
 tag()
 public static string endTag ( name )
 name	string|boolean|null	
 The tag name. If name is null or false, the corresponding content will be rendered without any tag.
 return	string	
 The generated end tag
 error() public static method
 Generates a tag that contains the first validation error of the specified model attribute.

 Note that even if there is no validation error, this method will still return an empty error tag.
 public static string error ( model, attribute, options = [] )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for the format about attribute expression.
 options	array	
 The tag options in terms of name-value pairs. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered.
 The following options are specially handled:
 tag: this specifies the tag name. If not set, "div" will be used. See also tag().
 encode: boolean, if set to false then the error message won't be encoded.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated label tag
 errorSummary() public static method
 Generates a summary of the validation errors.

 If there is no validation error, an empty error summary markup will still be generated, but it will be hidden.
 public static string errorSummary ( models, options = [] )
 models	yii\base\Model|yii\base\Model[]	
 The model(s) whose validation errors are to be displayed.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 header: string, the header HTML for the error summary. If not set, a default prompt string will be used.
 footer: string, the footer HTML for the error summary. Defaults to empty string.
 encode: boolean, if set to false then the error messages won't be encoded. Defaults to true.
 showAllErrors: boolean, if set to true every error message for each attribute will be shown otherwise only the first error message for each attribute will be shown. Defaults to false. Option is available since 2.0.10.
 The rest of the options will be rendered as the attributes of the container tag.
 return	string	
 The generated error summary
 escapeJsRegularExpression() public static method (available since version 2.0.6)
 Escapes regular expression to use in JavaScript
 public static string escapeJsRegularExpression ( regexp )
 regexp	string	
 The regular expression to be escaped.
 return	string	
 The escaped result.
 fileInput() public static method
 Generates a file input field.

 To use a file input field, you should set the enclosing form's "enctype" attribute to be "multipart/form-data". After the form is submitted, the uploaded file information can be obtained via _FILES[name] (see PHP documentation).
 public static string fileInput ( name, value = null, options = [] )
 name	string	
 The name attribute.
 value	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated file input tag
 getAttributeName() public static method
 Returns the real attribute name from the given attribute expression.

 An attribute expression is an attribute name prefixed and/or suffixed with array indexes. It is mainly used in tabular data input and/or input of array type. Below are some examples:

 [0]content is used in tabular data input to represent the "content" attribute for the first model in tabular input;
 dates[0] represents the first array element of the "dates" attribute;
 [0]dates[0] represents the first array element of the "dates" attribute for the first model in tabular input.
 If attribute has neither prefix nor suffix, it will be returned back without change.
 public static string getAttributeName ( attribute )
 attribute	string	
 The attribute name or expression
 return	string	
 The attribute name without prefix and suffix.
 throws	yii\base\InvalidParamException	
 if the attribute name contains non-word characters.
 getAttributeValue() public static method
 Returns the value of the specified attribute name or expression.

 For an attribute expression like [0]dates[0], this method will return the value of model->dates[0]. See getAttributeName() for more details about attribute expression.

 If an attribute value is an instance of yii\db\ActiveRecordInterface or an array of such instances, the primary value(s) of the AR instance(s) will be returned instead.
 public static string|array getAttributeValue ( model, attribute )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression
 return	string|array	
 The corresponding attribute value
 throws	yii\base\InvalidParamException	
 if the attribute name contains non-word characters.
 getInputId() public static method
 Generates an appropriate input ID for the specified attribute name or expression.

 This method converts the result getInputName() into a valid input ID. For example, if getInputName() returns Post[content], this method will return post-content.
 public static string getInputId ( model, attribute )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression. See getAttributeName() for explanation of attribute expression.
 return	string	
 The generated input ID
 throws	yii\base\InvalidParamException	
 if the attribute name contains non-word characters.
 getInputName() public static method
 Generates an appropriate input name for the specified attribute name or expression.

 This method generates a name that can be used as the input name to collect user input for the specified attribute. The name is generated according to the form name of the model and the given attribute name. For example, if the form name of the Post model is Post, then the input name generated for the content attribute would be Post[content].

 See getAttributeName() for explanation of attribute expression.
 public static string getInputName ( model, attribute )
 model	yii\base\Model	
 The model object
 attribute	string	
 The attribute name or expression
 return	string	
 The generated input name
 throws	yii\base\InvalidParamException	
 if the attribute name contains non-word characters.
 hiddenInput() public static method
 Generates a hidden input field.
 public static string hiddenInput ( name, value = null, options = [] )
 name	string	
 The name attribute.
 value	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated hidden input tag
 img() public static method
 Generates an image tag.
 public static string img ( src, options = [] )
 src	array|string	
 The image URL. This parameter will be processed by yii\helpers\Url::to().
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated image tag
 input() public static method
 Generates an input type of the given type.
 public static string input ( type, name = null, value = null, options = [] )
 type	string	
 The type attribute.
 name	string	
 The name attribute. If it is null, the name attribute will not be generated.
 value	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated input tag
 jsFile() public static method
 Generates a script tag that refers to an external JavaScript file.

 See also yii\helpers\Url::to().
 public static string jsFile ( url, options = [] )
 url	string	
 The URL of the external JavaScript file. This parameter will be processed by yii\helpers\Url::to().
 options	array	
 The tag options in terms of name-value pairs. The following option is specially handled:
 condition: specifies the conditional comments for IE, e.g., lt IE 9. When this is specified, the generated script tag will be enclosed within the conditional comments. This is mainly useful for supporting old versions of IE browsers.
 The rest of the options will be rendered as the attributes of the resulting script tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated script tag
 label() public static method
 Generates a label tag.
 public static string label ( content, for = null, options = [] )
 content	string	
 Label text. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is is coming from end users, you should encode() it to prevent XSS attacks.
 for	string	
 The ID of the HTML element that this label is associated with. If this is null, the "for" attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated label tag
 listBox() public static method
 Generates a list box.
 public static string listBox ( name, selection = null, items = [], options = [] )
 name	string	
 The input name
 selection	string|array|null	
 The selected value(s). String for single or array for multiple selection(s).
 items	array	
 The option data items. The array keys are option values, and the array values are the corresponding option labels. The array can also be nested (i.e. some array values are arrays too). For each sub-array, an option group will be generated whose label is the key associated with the sub-array. If you have a list of data models, you may convert them into the format described above using yii\helpers\ArrayHelper::map().
 Note, the values and labels will be automatically HTML-encoded by this method, and the blank spaces in the labels will also be HTML-encoded.
 options	array	
 The tag options in terms of name-value pairs. The following options are specially handled:
 prompt: string, a prompt text to be displayed as the first option. Since version 2.0.11 you can use an array to override the value and to set other tag attributes:
 ['text' => 'Please select', 'options' => ['value' => 'none', 'class' => 'prompt', 'label' => 'Select']],
 options: array, the attributes for the select option tags. The array keys must be valid option values, and the array values are the extra attributes for the corresponding option tags. For example,
 [
 'value1' => ['disabled' => true],
 'value2' => ['label' => 'value 2'],
 ];
 groups: array, the attributes for the optgroup tags. The structure of this is similar to that of 'options', except that the array keys represent the optgroup labels specified in items.
 unselect: string, the value that will be submitted when no option is selected. When this attribute is set, a hidden field will be generated so that if no option is selected in multiple mode, we can still obtain the posted unselect value.
 encodeSpaces: bool, whether to encode spaces in option prompt and option value with &nbsp; character. Defaults to false.
 encode: bool, whether to encode option prompt and option value characters. Defaults to true. This option is available since 2.0.3.
 The rest of the options will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated list box tag
 mailto() public static method
 Generates a mailto hyperlink.
 public static string mailto ( text, email = null, options = [] )
 text	string	
 Link body. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is coming from end users, you should consider encode() it to prevent XSS attacks.
 email	string	
 Email address. If this is null, the first parameter (link body) will be treated as the email address and used.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated mailto link
 ol() public static method
 Generates an ordered list.
 public static string ol ( items, options = [] )
 items	array|Traversable	
 The items for generating the list. Each item generates a single list item. Note that items will be automatically HTML encoded if options['encode'] is not set or true.
 options	array	
 Options (name => config) for the radio button list. The following options are supported:
 encode: boolean, whether to HTML-encode the items. Defaults to true. This option is ignored if the item option is specified.
 itemOptions: array, the HTML attributes for the li tags. This option is ignored if the item option is specified.
 item: callable, a callback that is used to generate each individual list item. The signature of this callback must be:
 function (item, index)
 where index is the array key corresponding to item in items. The callback should return the whole list item tag.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated ordered list. An empty string is returned if items is empty.
 passwordInput() public static method
 Generates a password input field.
 public static string passwordInput ( name, value = null, options = [] )
 name	string	
 The name attribute.
 value	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated password input tag
 radio() public static method
 Generates a radio button input.
 public static string radio ( name, checked = false, options = [] )
 name	string	
 The name attribute.
 checked	boolean	
 Whether the radio button should be checked.
 options	array	
 The tag options in terms of name-value pairs. See booleanInput() for details about accepted attributes.
 return	string	
 The generated radio button tag
 radioList() public static method
 Generates a list of radio buttons.

 A radio button list is like a checkbox list, except that it only allows single selection.
 public static string radioList ( name, selection = null, items = [], options = [] )
 name	string	
 The name attribute of each radio button.
 selection	string|array|null	
 The selected value(s). String for single or array for multiple selection(s).
 items	array	
 The data item used to generate the radio buttons. The array keys are the radio button values, while the array values are the corresponding labels.
 options	array	
 Options (name => config) for the radio button list container tag. The following options are specially handled:
 tag: string|false, the tag name of the container element. False to render radio buttons without container. See also tag().
 unselect: string, the value that should be submitted when none of the radio buttons is selected. By setting this option, a hidden input will be generated.
 encode: boolean, whether to HTML-encode the checkbox labels. Defaults to true. This option is ignored if item option is set.
 separator: string, the HTML code that separates items.
 itemOptions: array, the options for generating the radio button tag using radio().
 item: callable, a callback that can be used to customize the generation of the HTML code corresponding to a single item in items. The signature of this callback must be:
 function (index, label, name, checked, value)
 where index is the zero-based index of the radio button in the whole list; label is the label for the radio button; and name, value and checked represent the name, value and the checked status of the radio button input, respectively.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated radio button list
 removeCssclass() public static method
 Removes a CSS class from the specified options.
 public static void removeCssclass ( &options, class )
 options	array	
 The options to be modified.
 class	string|array	
 The CSS class(es) to be removed
 removeCssStyle() public static method
 Removes the specified CSS style from the HTML options.

 For example,

 Html::removeCssStyle(options, ['width', 'height']);
 See also addCssStyle().
 public static void removeCssStyle ( &options, properties )
 options	array	
 The HTML options to be modified.
 properties	string|array	
 The CSS properties to be removed. You may use a string if you are removing a single property.
 renderSelectOptions() public static method
 Renders the option tags that can be used by dropDownList() and listBox().
 public static string renderSelectOptions ( selection, items, &tagOptions = [] )
 selection	string|array|null	
 The selected value(s). String for single or array for multiple selection(s).
 items	array	
 The option data items. The array keys are option values, and the array values are the corresponding option labels. The array can also be nested (i.e. some array values are arrays too). For each sub-array, an option group will be generated whose label is the key associated with the sub-array. If you have a list of data models, you may convert them into the format described above using yii\helpers\ArrayHelper::map().
 Note, the values and labels will be automatically HTML-encoded by this method, and the blank spaces in the labels will also be HTML-encoded.
 tagOptions	array	
 The options parameter that is passed to the dropDownList() or listBox() call. This method will take out these elements, if any: "prompt", "options" and "groups". See more details in dropDownList() for the explanation of these elements.
 return	string	
 The generated list options
 renderTagAttributes() public static method
 Renders the HTML tag attributes.

 Attributes whose values are of boolean type will be treated as boolean attributes.

 Attributes whose values are null will not be rendered.

 The values of attributes will be HTML-encoded using encode().

 The "data" attribute is specially handled when it is receiving an array value. In this case, the array will be "expanded" and a list data attributes will be rendered. For example, if 'data' => ['id' => 1, 'name' => 'yii'], then this will be rendered: data-id="1" data-name="yii". Additionally 'data' => ['params' => ['id' => 1, 'name' => 'yii'], 'status' => 'ok'] will be rendered as: data-params='{"id":1,"name":"yii"}' data-status="ok".
 public static string renderTagAttributes ( attributes )
 attributes	array	
 Attributes to be rendered. The attribute values will be HTML-encoded using encode().
 return	string	
 The rendering result. If the attributes are not empty, they will be rendered into a string with a leading white space (so that it can be directly appended to the tag name in a tag. If there is no attribute, an empty string will be returned.
 resetButton() public static method
 Generates a reset button tag.
 public static string resetButton ( content = 'Reset', options = [] )
 content	string	
 The content enclosed within the button tag. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is is coming from end users, you should consider encode() it to prevent XSS attacks.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated reset button tag
 resetInput() public static method
 Generates a reset input button.
 public static string resetInput ( label = 'Reset', options = [] )
 label	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The attributes of the button tag. The values will be HTML-encoded using encode(). Attributes whose value is null will be ignored and not put in the tag returned. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated button tag
 script() public static method
 Generates a script tag.
 public static string script ( content, options = [] )
 content	string	
 The script content
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated script tag
 style() public static method
 Generates a style tag.
 public static string style ( content, options = [] )
 content	string	
 The style content
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated style tag
 submitButton() public static method
 Generates a submit button tag.

 Be careful when naming form elements such as submit buttons. According to the jQuery documentation there are some reserved names that can cause conflicts, e.g. submit, length, or method.
 public static string submitButton ( content = 'Submit', options = [] )
 content	string	
 The content enclosed within the button tag. It will NOT be HTML-encoded. Therefore you can pass in HTML code such as an image tag. If this is is coming from end users, you should consider encode() it to prevent XSS attacks.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated submit button tag
 submitInput() public static method
 Generates a submit input button.

 Be careful when naming form elements such as submit buttons. According to the jQuery documentation there are some reserved names that can cause conflicts, e.g. submit, length, or method.
 public static string submitInput ( label = 'Submit', options = [] )
 label	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated button tag
 tag() public static method
 Generates a complete HTML tag.

 See also:

 beginTag()
 endTag()
 public static string tag ( name, content = '', options = [] )
 name	string|boolean|null	
 The tag name. If name is null or false, the corresponding content will be rendered without any tag.
 content	string	
 The content to be enclosed between the start and end tags. It will not be HTML-encoded. If this is coming from end users, you should consider encode() it to prevent XSS attacks.
 options	array	
 The HTML tag attributes (HTML options) in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered.
 For example when using ['class' => 'my-class', 'target' => '_blank', 'value' => null] it will result in the html attributes rendered like this: class="my-class" target="_blank".
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated HTML tag
 textInput() public static method
 Generates a text input field.
 public static string textInput ( name, value = null, options = [] )
 name	string	
 The name attribute.
 value	string	
 The value attribute. If it is null, the value attribute will not be generated.
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated text input tag
 textarea() public static method
 Generates a text area input.
 public static string textarea ( name, value = '', options = [] )
 name	string	
 The input name
 value	string	
 The input value. Note that it will be encoded using encode().
 options	array	
 The tag options in terms of name-value pairs. These will be rendered as the attributes of the resulting tag. The values will be HTML-encoded using encode(). If a value is null, the corresponding attribute will not be rendered. See renderTagAttributes() for details on how attributes are being rendered. The following special options are recognized:
 doubleEncode: whether to double encode HTML entities in value. If false, HTML entities in value will not be further encoded. This option is available since version 2.0.11.
 return	string	
 The generated text area tag
 ul() public static method
 Generates an unordered list.
 public static string ul ( items, options = [] )
 items	array|Traversable	
 The items for generating the list. Each item generates a single list item. Note that items will be automatically HTML encoded if options['encode'] is not set or true.
 options	array	
 Options (name => config) for the radio button list. The following options are supported:
 encode: boolean, whether to HTML-encode the items. Defaults to true. This option is ignored if the item option is specified.
 separator: string, the HTML code that separates items. Defaults to a simple newline ("\n"). This option is available since version 2.0.7.
 itemOptions: array, the HTML attributes for the li tags. This option is ignored if the item option is specified.
 item: callable, a callback that is used to generate each individual list item. The signature of this callback must be:
 function (item, index)
 where index is the array key corresponding to item in items. The callback should return the whole list item tag.
 See renderTagAttributes() for details on how attributes are being rendered.
 return	string	
 The generated unordered list. An empty list tag will be returned if items is empty.

 */

enum TextDirections : string {
	LeftToRight = "ltr", // text direction
	RightToLeft = "rtl", // Right-to-left text direction
	Auto = "auto" // Let the browser figure out the text direction, based on the content (only recommended if the text direction is unknown)
}

enum DraggableModes : string {
	IsDraggable = "true", //	Specifies that the element is draggable
	NotDraggable = "false", //	Specifies that the element in not draggable
	AutoDraggable = "auto" 	// Uses the default behavior of the browser
}

version(test_uim_html) { unittest {
//	HTML.HEAD(
//		CSS
//		("h1", ["color":"red"])
//		("h2", ["color":"blue"]),
//		HTML
//		(H1("xx", ["eins", "zwei"]))
//		(H1("xx", ["eins", "zwei"])),
//		JS
//		(VAR("x", "1"))
//		(IF("x>0", "x = 0"))
//		)
//		.BODY(
//			CSS
//			("h1", ["color":"red"])
//			("h2", ["color":"blue"]),
//			HTML
//			(H1("xx", ["eins", "zwei"]))
//			(H1("xx", ["eins", "zwei"])),
//			JS
//			(VAR("x", "1"))
//			(IF("x>0", "x = 0"))
//			).toString;
}}

class DH5CENTER : DH5Obj {
	mixin(H5This!("CENTER"));
}
mixin(H5Short!"CENTER");

version(test_uim_html) { unittest {
		// TODO Add Test
		}}