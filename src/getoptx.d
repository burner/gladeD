module getoptx;

import std.stdio;
import std.getopt;

//private import std.contracts;
private import std.typetuple;
private import std.typecons;
private import std.conv;

alias Tuple!(bool, "help", Option[], "options") GetOptRslt;

GetOptRslt getoptX(T...)(ref string[] args, T opts)
{
    Option[] helpMsg = GetoptHelp(opts); // extract all help strings

    bool helpPrinted = false; // state tells if called with "--help"

    getopt(args, GetoptEx!(opts), "help", &helpPrinted);

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

struct Option {
	string op;
	string msg;
	bool end;

	static Option opCall(string o, string h) {
		Option ret;
		ret.op = o;
		ret.msg = h;
		return ret;
	}

	static Option opCall() {
		Option ret;
		ret.end = true;
		return ret;
	}
}

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
            string option  = to!(string)(opts[0]);
            string help    = to!(string)(opts[1]);

            return([Option(option,help)]~GetoptHelp(opts[3 .. $]) );
        }
    }
    else
    {
        return [Option()];
    }
}
