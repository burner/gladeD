module stack;

struct Stack(T) {
	private T[] stack;
	private size_t stptr;

	pure void init(size_t size = 128) @safe {
		this.stack = new T[size];
		this.stptr = 0;
	}

	pure ref Stack!(T) push(T elem) @safe {
		if(stack is null) {
			this.init();
		}
		if(this.stptr+1 == stack.length) {
			this.stack.length = this.stack.length*2;
		}
		this.stack[this.stptr++] = elem;
		return this;
	}

	pure void pop() @safe nothrow {
		if(this.stptr > 0) {
			--this.stptr;
		}
	}

	pure bool empty() const @safe nothrow {
		return this.stptr == 0;
	}

	pure ref T top() @safe nothrow {
		if(this.stptr < 0) {
			assert(0, "Stack Empty");
		}
		return this.stack[this.stptr-1];
	}

	@property pure size_t length() const @safe nothrow {
		return this.stptr;
	}

	pure size_t getCapazity() const @safe nothrow {
		return this.stack.length;
	}

	pure void clear() @safe nothrow {
		this.stptr = 0;
	}
}

unittest {
	Stack!(int) i;
	i.push(44);
	assert(i.top() == 44);
	i.push(45);
	assert(i.top() == 45);
	i.pop();
	assert(i.top() == 44);
	i.pop();
	assert(i.empty());

	class Tmp {
		uint a = 44;
	}

	Stack!(Tmp) j;
	j.push(new Tmp());
	j.top().a = 88;
	assert(j.top().a == 88);
	j.push(new Tmp());
	j.push(new Tmp());
	j.push(new Tmp());
	assert(j.length() == 4);
}
