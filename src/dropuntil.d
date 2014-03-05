module dropuntil;

import std.conv : to;
import std.functional : unaryFun;
import std.range : isInputRange;
import std.traits : Unqual;
import std.array : array, empty, front, popFront;
import std.stdio;

template dropUntil(alias pred) if (is(typeof(unaryFun!pred)))
{
    auto dropUntil(InputRange)(InputRange rs) if (isInputRange!(Unqual!InputRange))
    {
        return DropUntil!(unaryFun!pred, InputRange)(rs);
    }
}

struct DropUntil(alias pred, InputRange) {
	public:
		this(InputRange input) {
			this.input = input;
			this.eatUntil();
		}

		@property void popFront() {
			this.input.popFront;
		}

		@property bool empty() {
			return this.input.empty;
		}

		@property auto front() {
			return this.input.front;
		}

	private:	
		void eatUntil() {
			for(; !input.empty(); input.popFront()) {
				auto f = input.front;
				if(pred(f)) {
					break;
				}
			}
		}

		InputRange input;
}

unittest {
	auto a = [1,2,3,4,5,6,7];

	auto a2 = a.dropUntil!(a => a > 2).array;
	assert(a2 == a[2 .. $], to!string(a2));
}
