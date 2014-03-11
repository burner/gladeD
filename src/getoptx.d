module getoptx;

public import std.getopt;

import std.typetuple;
import std.typecons;
import std.conv;
import std.array : back, empty, split;

alias Tuple!(bool, "help", Option[], "options") GetOptRslt;

GetOptRslt getoptX(T...)(ref string[] args, T opts)
{
    Option[] helpMsg = GetoptHelp(opts); // extract all help strings

    bool helpPrinted = false; // state tells if called with "--help"

    getopt(args, GetoptEx!(opts), "h|help", &helpPrinted);

	GetOptRslt rslt;
	rslt.help = helpPrinted;
	rslt.options = helpMsg;

    return rslt;
}

private template GetoptEx(TList...)
{
    static if (TList.length)
    {
        static if (is(typeof(TList[0]) : config))
        {
            // it's a configuration flag, lets move on
            alias TypeTuple!(TList[0],GetoptEx!(TList[1 .. $])) GetoptEx;
        }
        else
        {
            // it's an option string, eat help string
            alias TypeTuple!(TList[0],TList[2],GetoptEx!(TList[3 .. $])) GetoptEx;
        }
    }
    else
    {
        alias TList GetoptEx;
    }
}

alias Tuple!(string, "optShort", string, "optLong", string, "help") Option;

private Option[] GetoptHelp(T...)(T opts)
{
    static if (opts.length)
    {
        static if (is(typeof(opts[0]) : config))
        {
            // it's a configuration flag, skip it
            return GetoptHelp(opts[1 .. $]);
        }
        else
        {
            // it's an option string
			auto sp = split(opts[0], '|');
			Option ret;
			if (sp.length > 1) 
			{
				ret.optShort = "-" ~ (sp[0].length < sp[1].length ? 
					sp[0] : sp[1]);
				ret.optLong = "--" ~ (sp[0].length > sp[1].length ? 
					sp[0] : sp[1]);
			} 
			else 
			{
				ret.optLong = "--" ~ sp[0];
			}
			ret.help = opts[1];

            return([ret]~GetoptHelp(opts[3 .. $]) );
        }
    }
    else
    {
		Option help;
		help.optShort = "-h";
		help.optLong = "--help";
		help.help = "This help.";
        return [help];
    }
}

void defaultGetoptPrinter(string text, Option[] opt) {
	import std.stdio : write, writeln, writef, writefln;
	import std.algorithm : min, max;

	writeln(text);
	writeln();
	size_t ls, ll;
	foreach(it; opt) {
		ls = max(ls, it.optShort.length);	
		ll = max(ll, it.optLong.length);	
	}

	size_t argLength = ls + ll + 2;
	size_t rest = 79 - argLength;

	foreach(it; opt) {
		writef("%*s %*s ", ls, it.optShort, ll, it.optLong);
		string helpMsg = it.help;
		auto curLine = helpMsg[0 .. min($, rest)];
		write(curLine);
		helpMsg = helpMsg[min($, rest) .. $];
		if(curLine.back != ' ' && !helpMsg.empty) {
			writeln('-');
		} else {
			writeln();
		}
		while(!helpMsg.empty) {
			curLine = helpMsg[0 .. min($, rest)];
			helpMsg = helpMsg[min($, rest) .. $];
			writef("%*s", argLength, " ");
			write(curLine);
			if(curLine.back != ' ' && !helpMsg.empty) {
				writeln('-');
			} else {
				writeln();
			}
		}
	}
}
