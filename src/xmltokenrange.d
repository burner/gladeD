module xmltokenrange;

//import std.array : Appender, appender, front, empty, popFront;
import std.array;
import std.algorithm : equal, count, countUntil;
import std.conv : to;
import std.encoding : index;
import std.exception : enforce;
import std.stdio : writeln, writefln;
import std.uni : isWhite, isNumber;
import std.range : isInputRange, lockstep;
import std.format : format;
import std.string : stripLeft, stripRight, indexOf, CaseSensitive, strip;
import std.regex : ctRegex, match, regex, matchAll, popFrontN;
import std.traits : isSomeChar, isAssociativeArray;
import std.functional : binaryFun;
import std.algorithm : min;

import std.logger;
import fixedsizehashmap;

ptrdiff_t stripLeftIdx(C)(C[] str) @safe pure 
{
	bool foundSome = false;
    foreach (i, dchar c; str)
    {
        if(!std.uni.isWhite(c)) {
            return i;
		} else {
			foundSome = true;
		}
    }

	if(foundSome) {
		return str.length;
	}
    return 0;
}

ptrdiff_t indexOfNone(Char,R2)(const(Char)[] haystack, const(R2)[] needles,
		const size_t startIdx, CaseSensitive cs = CaseSensitive.yes) @safe pure
    if (isSomeChar!Char && isSomeChar!R2 && 
		is(typeof(binaryFun!"a == b"(haystack.front, needles.front))))
{	
    if (startIdx < haystack.length)
    {
        ptrdiff_t foundIdx = indexOfNone(haystack[startIdx .. $], needles, cs);
        if (foundIdx != -1)
        {
            return foundIdx + cast(ptrdiff_t)startIdx;
        }
    }
    return -1;
}

ptrdiff_t indexOfNone(Char,R2)(const(Char)[] haystack, const(R2)[] needles,
		CaseSensitive cs = CaseSensitive.yes) @safe pure
    if (isSomeChar!Char && isSomeChar!R2 && 
		is(typeof(binaryFun!"a == b"(haystack.front, needles.front))))
{
    if (cs == CaseSensitive.yes)
    {
		foreach (ptrdiff_t i, dchar c; haystack)
		{
			foreach (dchar o; needles)
			{
				if (c != o)
				{
					return i;
				}	
			}
		}
	}
	else
	{
		foreach (ptrdiff_t i, dchar c; haystack)
		{
			dchar cLow = std.uni.toLower(c);
			foreach (dchar o; needles)
			{
				if (cLow != o)
				{
					return i;
				}	
			}
		}
	}

	return -1;
}

ptrdiff_t indexOfAny(Char,R2)(const(Char)[] haystack, const(R2)[] needles,
		CaseSensitive cs = CaseSensitive.yes) @safe pure
    if (isSomeChar!Char && isSomeChar!R2 && 
		is(typeof(binaryFun!"a == b"(haystack.front, needles.front))))
{
    if (cs == CaseSensitive.yes)
    {
		foreach (ptrdiff_t i, dchar c; haystack)
		{
			foreach (dchar o; needles)
			{
				if (c == o)
				{
					return i;
				}	
			}
		}
	}
	else
	{
		foreach (ptrdiff_t i, dchar c; haystack)
		{
			dchar cLow = std.uni.toLower(c);
			foreach (dchar o; needles)
			{
				if (cLow == o)
				{
					return i;
				}	
			}
		}
	}

	return -1;
}

unittest {
	ptrdiff_t i = "helloWorld".indexOfAny("Wr");
	assert(i == 5);
	i = "öällo world".indexOfAny("lo ");
	assert(i == 4, to!string(i));
}

ptrdiff_t indexOfAny(Char,R2)(const(Char)[] haystack, const(R2)[] needles,
		const size_t startIdx, CaseSensitive cs = CaseSensitive.yes) @safe pure
    if (isSomeChar!Char && isSomeChar!R2 && 
		is(typeof(binaryFun!"a == b"(haystack.front, needles.front))))
{	
    if (startIdx < haystack.length)
    {
        ptrdiff_t foundIdx = indexOfAny(haystack[startIdx .. $], needles, cs);
        if (foundIdx != -1)
        {
            return foundIdx + cast(ptrdiff_t)startIdx;
        }
    }
    return -1;
}

void eatWhitespace(C)(ref C c) @safe pure {
	static if(is(C == string)) {
		c = c.strip();
	} else {
		auto idx = stripLeftIdx(c);
		if(idx == c.length) {
			c = c[idx-1 .. $];
		} else {
			c = c[idx .. $];
		}
	}
}

unittest {
	auto s = "    foo";
	eatWhitespace(s);
	assert(equal(s, "foo"));
}

string eatKey(C)(ref C c) @trusted pure {
	eatWhitespace(c);
	auto endOfKey = c.indexOf("=");
	enforce(endOfKey != -1);
	string name = c[0..endOfKey];
	c = c[endOfKey+1 .. $];
	
	return name.strip();
}

unittest {
	string input = "   \tfoo = ";
	auto n = eatKey(input);
	assert(n == "foo", "\"" ~ n ~ "\"");
	assert(input == "", "\"" ~ input ~ "\"");
}

string eatAttri(C)(ref C c) @trusted pure {
	eatWhitespace(c);
	auto firstTick = c.indexOfAny("\"'");
	string attri;
	if(firstTick != -1) {
		dchar foundString = c[firstTick];
		c = c[firstTick+1 .. $];

		size_t i = 0;
		while(true) {
			if(i > 0 && c[i] == foundString && c[i-1] != '\\') {
				break;
			} else if(i == 0 && c[i] == foundString) {
				break;
			} else {
				++i;
			}
		}

		attri = c[0 .. i];
		c = c[i .. $];
		if(c[0] == foundString) {
			c = c[1 .. $];
		}
		eatWhitespace(c);
	} else {
		auto i = c.countUntil!(isNumber);
		attri = c[0 .. i];
		c = c[i+1 .. $];
		eatWhitespace(c);
	}

	return attri;
}

unittest {
	string input = " \"asdf\"  ";
	string attri = eatAttri(input);
	assert(attri == "asdf", "\"" ~ attri ~ "\" " ~ input);
	assert(input.empty, "\"" ~ input ~ "\"");
}

version(XML_AA) {
void insert(T,K,V)(ref T t, K k, V v) @trusted 
		if(isAssociativeArray!T) {
	t[k] = v;
}

bool contains(T,K)(ref T t, K k) @trusted nothrow 
		if(isAssociativeArray!T) {
	return (k in t) !is null;
}
} else {
bool contains(T,K)(ref T t, K k) @trusted nothrow  {
	return t.contains(k);
}

void insert(T,K,V)(ref T t, K k, V v) @trusted {
	t.insert(k,v);
}
}


enum XmlTokenKind {
	Invalid,
	OpenClose,
	Open,
	Text,
	Comment,
	Type,
	Close
}

struct XmlToken {
public:
	this(string d, size_t l) {
		this.data = d;
		this.line = l;
		if(this.data.length == 0) {
			this.kind = XmlTokenKind.Invalid;
			return;
		}
		this.kind = this.getKind();
		if(this.kind == XmlTokenKind.Open || this.kind ==
				XmlTokenKind.OpenClose || this.kind == XmlTokenKind.Close) {
			this.readName();
		}
		if(this.kind == XmlTokenKind.Open || this.kind ==
				XmlTokenKind.OpenClose || this.kind == XmlTokenKind.Close) {
			this.readAttributes();
		}
	}

	ref string opIndex(string key) {
		version(XML_AA) {
			return this.attributes[key];
		} else {
			return this.attributes[key].value;
		}
	}

	string name;
	XmlTokenKind kind = XmlTokenKind.Invalid;
	version(XML_AA) {
		string[string] attributes;
	} else {
		FashMap!(string,string) attributes;
	}
	string data;
	size_t line;

private:
	XmlTokenKind getKind() {
		assert(this.data.length, format("no data at line %u", this.line));
		if(this.data[0] != '<') {
			return XmlTokenKind.Text;
		} else if(this.data[0] == '<') {
			this.data.popFront();
			if(this.data[0] == '/') {
				this.data.popFront();
				return XmlTokenKind.Close;
			} else if(this.data[0] == '!') {
				this.data.popFront();
				return XmlTokenKind.Comment;
			} else if(this.data[0] == '?') {
				this.data.popFront();
				return XmlTokenKind.Type;
			} else if(this.data.length > 1 && this.data[$-2] == '/') {
				this.data.popFront();
				return XmlTokenKind.OpenClose;
			} else {
				return XmlTokenKind.Open;
			}
		} 
		assert(false);
	}

	ptrdiff_t readNameBeginIdx() pure {
		if(this.data.length > 0) {
			return this.data.stripLeftIdx();
		} else {
			return 0;
		}
	}

	ptrdiff_t readNameEndIdx() pure {
		auto lowIdx = readNameBeginIdx();
		return this.data[lowIdx .. $].indexOfAny(" >/")+lowIdx;
	}

	void readName() pure {
		auto low = this.readNameBeginIdx();
		auto high = this.readNameEndIdx();
		assert(low <= this.data.length, this.data);
		assert(high <= this.data.length, this.data);
		if(low < high) {
			this.name = this.data[low .. high];
			this.data = this.data[high .. $];
		} else if(!this.data.empty) {
			this.data.popFront();
		}
	}

	void readAttributes() {
		while(!this.data.empty) {
			eatWhitespace(this.data);

			auto end = this.data.indexOf(">");
			if(end == 0) {
				break;
			}
			end = this.data.indexOf("/>");
			if(end == 0) {
				break;
			}

			eatWhitespace(this.data);
			string key;
		    try	{
				key = eatKey(this.data);
			} catch(Exception e) {
				assert(false, format("unable to read key at line %u", this.line));
			}
			eatWhitespace(this.data);
			string attri = eatAttri(this.data);
			eatWhitespace(this.data);
			version(XML_AA) {
				this.attributes[key] = attri;
			} else {
				insert(this.attributes, key, attri);
			}
		}
	}

	//static auto re = ctRegex!("\\s*(\\w+)\\s*=\\s*\"(\\w+)\"\\s*");
}

struct XmlTokenRange(InputRange) {
public:
	@property InputRange input() {
		return input_;
	}

	@property void input(InputRange i) {
		input_ = i;
		this.store_.clear();
		this.readFromRange();
	}

	@property auto front() {
		return XmlToken(this.store_.data(), line);
	}

	@property void popFront() {
		this.store_.clear();
		readFromRange();
	}

	@property bool empty() {
		return this.store_.data().empty && std.array.empty(this.input_);
	}

private: 
	size_t line;

	void equalCrocos() {
		dchar it;
		dchar prev = '\0';
		size_t numCrocos = 0;
		//foreach(it; this.input_) {
		for(; !input_.empty(); input_.popFront()) {
			it = input_.front();
	
			if(input_.front() == '\n' || input_.front() == '\r') {
				++this.line;
			}
			if(it == '<' && prev != '\\') {
				++numCrocos;
			} else if(it == '>' && prev != '\\') {
				--numCrocos;
			}
	
			prev = it;
	
			if(!numCrocos) {
				this.store_.put(it);
				input_.popFront();
				break;
			}
			this.store_.put(it);
		}
	}

	void eatTillCroco() {
		dchar it;
		dchar prev = '\0';
		for(; !input_.empty(); input_.popFront()) {
			it = input_.front();
			if(input_.front() == '\n' || input_.front() == '\r') {
				++this.line;
			}
			if(it == '<' && prev != '\\') {
				break;
			}
			this.store_.put(it);
			prev = it;
		}
	}

	void readFromRange() {
		eatWhiteSpace();
		if(this.input_.empty) {
			return;
		}

		if(this.input_.front == '<') {
			equalCrocos();
			return;
		} else {
			eatTillCroco();
			return;
		}
	}

	void eatWhiteSpace() {
		while(!input_.empty && isWhite(std.array.front(input_))) {
			if(input_.front() == '\n' || input_.front() == '\r') {
				++this.line;
			}
			input_.popFront();
		}
	}

	InputRange input_;
	Appender!string store_;
}

auto xmlTokenRange(InputRange)(InputRange input) {
	XmlTokenRange!InputRange ret;
	ret.input = input;
   	return ret;	
}

unittest {
	auto s = "some fun string<>";
	auto r = xmlTokenRange(s);

	auto f = r.front();
	assert(f.kind == XmlTokenKind.Text);
	r.popFront();
	f = r.front();
	assert(f.kind == XmlTokenKind.Open, to!string(f.kind));
}

unittest {
	static assert(isInputRange!(XmlTokenRange!string));
}

unittest {
	string testString = "hello";
	auto r = xmlTokenRange(testString);
	assert(r.front.data == "hello", r.front.data);
}

unittest {
	string testString = "<hello>";
	auto r = xmlTokenRange(testString);
	assert(r.front.name == "hello", r.front.name);
}

unittest {
	string testString = "</hello>";
	auto r = xmlTokenRange(testString);
	assert(r.front.name == "hello", "\"" ~ r.front.name ~ "\"");
}

unittest {
	string testString = "<hello>";
	string testString2 = "<hello>";
	auto test = testString ~ testString2;
	auto r = xmlTokenRange(test);
}

unittest {
	string testString = "<hello zzz=\"ttt\" world=\"foo\" args=\"bar\">";
	foreach(it; xmlTokenRange(testString)) {
		foreach(key, value; it.attributes) {
			//writefln("%s %s", key, value);
		}
	}
}
