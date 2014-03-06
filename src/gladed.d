import std.algorithm : map, uniq, sort;
import std.stdio : writeln, writefln, File;
import std.file : read;
import std.conv : to;
import std.array : appender, Appender;
import std.range : drop;
import std.format : formattedWrite, format;
import std.uni : toUpper;

import std.logger;

import stack;
import dropuntil;
import xmltokenrange;

struct UnderscoreCap {
	string data;
	bool capNext;
	bool isFirst;

	@property dchar front() pure @safe {
		if(capNext || isFirst) {
			return std.uni.toUpper(data.front);
		} else {
			return data.front;
		}
	}

	@property bool empty() pure @safe nothrow {
		return data.empty;
	}

	@property void popFront() {
		if(!data.empty()) {
			isFirst = false;
			data.popFront();
			if(!data.empty() && data.front == '_') {
				capNext = true;
				data.popFront();
			} else {
				capNext = false;
			}
		}
	}
}

UnderscoreCap underscoreCap(IRange)(IRange i) {
	UnderscoreCap r;
	r.isFirst = true;
	r.data = i;
	return r;
}

unittest {
	auto s = "hello_world";
	auto sm = underscoreCap(s);
	assert(to!string(sm) == "HelloWorld", to!string(sm));
}

void setupObjects(ORange,IRange)(ref ORange o, IRange i) {
	string curObject = "this";
	string curProperty;
	bool translateable;
	Stack!string objStack;

	foreach(it; i.drop(1)) {
		logF("%s %s %s", it.kind, it.kind == XmlTokenKind.Open || it.kind ==
			XmlTokenKind.Close ? it.name : "", !objStack.empty ?
			objStack.top() : ""
		);
		if(it.kind == XmlTokenKind.Open && it.name == "object") {
			curObject = it["id"];
			if(!objStack.empty) {
				o.formattedWrite("\t\t%s.add(this.%s);\n", objStack.top(),
					curObject
				);
			}
			objStack.push(curObject);
			logF("stack open size %u", objStack.length);
		} else if(it.kind == XmlTokenKind.Close && it.name == "object") {
			objStack.pop();
			logF("stack close size %u", objStack.length);
		} else if(it.kind == XmlTokenKind.Open && it.name == "property") {
			curProperty = it["name"];
			if(curProperty == "label" && it.attributes.contains("translatable")) 
			{
				translateable = it["translatable"] == "yes";
			}
		} else if(it.kind == XmlTokenKind.Open && it.name == "child") {
			logF("stack open size %u", objStack.length);
		} else if(it.kind == XmlTokenKind.Close && it.name == "child") {
		} else if(it.kind == XmlTokenKind.Text) {
			if(it.data == "True" || it.data == "False") {
				o.formattedWrite("\t\t%s.set%s();\n", curObject,
					underscoreCap(curProperty)
				);
			}
		}
	}
}

void createObjects(ORange,IRange)(ref ORange o, IRange i) {
	o.formattedWrite("\tthis() {\n");
	foreach(it; i) {
		if(it.kind == XmlTokenKind.Open && it.name == "object") {
			o.formattedWrite("\t\tthis.%s = new %s();\n", it["id"], 
				it["class"][3 .. $]
			);
		}
	}
	o.formattedWrite("\n");
	setupObjects(o, i);
	o.formattedWrite("\t}\n\n");
}

void main() {
	string input = cast(string)read("test1.glade");
	auto tokenRange = input.xmlTokenRange();
	auto payLoad = tokenRange.dropUntil!(a => a.kind == XmlTokenKind.Open && 
		a.name == "object" && a.attributes.contains("class") && 
		(a["class"] == "GtkWindow")
	);

	XmlToken clsType;
	auto elem = appender!(XmlToken[])();
	clsType = payLoad.front;
	foreach(it; payLoad.drop(1)) {
		if(it.kind == XmlTokenKind.Open && it.name == "object") {
			elem.put(it);
		}
	}

	foreach(ref XmlToken it; elem.data()) {
		logF("%s %s %s", it.name, it["class"], it["id"]);
	}

	log();

	auto of = File("output.d", "w");
	auto ofr = of.lockingTextWriter();

	string moduleName = "somemodule";
	string className = "SomeClass";

	ofr.formattedWrite("module %s;\n\n", moduleName);
	log();

	auto names = elem.data.map!(a => a["class"]);
	auto usedTypes = names.array.sort.uniq;
	foreach(it; usedTypes) {
		ofr.formattedWrite("import gtk.%s;\n", it[3 .. $]);
	}

	logF("%u ", clsType.attributes.length);

	ofr.formattedWrite("\nabstract class %s : %s {\n", className,
		clsType["class"]
	);

	log();
	createObjects(ofr, payLoad);
}
