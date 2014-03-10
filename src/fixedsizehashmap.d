module fixedsizehashmap;

import std.algorithm : sort;
import std.range : isRandomAccessRange;
import std.conv : to;

struct FashMap(K,V,const size_t cap = 64) {
	struct Pair(N,M) {
		N key;
		M value;

		this(N k, M v) {
			this.key = k;
			this.value = v;
		}
	}

private:
	size_t search(K key) const @trusted nothrow {
		int imax = (this.length - cast(size_t)1);
		int imin = 0;
		while(imin <= imax) {
			// calculate the midpoint for roughly equal partition
			int imid = (imin + ((imax - imin) / 2));
			if(data[cast(size_t)imid].key == key) {
				// key found at index imid
				return cast(size_t)imid; 
			// determine which subarray to search
			} else if(data[cast(size_t)imid].key < key) {
				// change min index to search
				// upper subarray
				imin = imid + 1;
			} else {
				// change max index to
				// search lower subarray
				imax = imid - 1;
			}
		}
		return size_t.max;
	}

	Pair!(K,V)[cap] data;
	size_t len;

public:
	@property pure size_t length() const @safe nothrow {
		return this.len;
	}
	
	@property pure size_t capacity() const @safe nothrow {
		return cap;
	}

	@property pure size_t empty() const @safe nothrow {
		return this.len == 0;
	}

	bool insert(K k, V v) @trusted {
		if(this.len == capacity) {
			throw new Exception("FashMap full, can not insert more element");
		}
		if(this.search(k) != size_t.max) {
			return false;	
		} else {
			this.data[this.len] = Pair!(K,V)(k, v);
			this.len++;
			sort!("a.key < b.key")(this.data[0 .. this.len]);
			return true;
		}
	}

	bool contains(K k) const @trusted nothrow {
		auto i = search(k);
		return i != size_t.max;
	}

	ref Pair!(K,V) opIndex(K k) @trusted {
		auto i = search(k);
		if(i != size_t.max) {
			return this.data[i];
		} else {
			throw new Exception("FashMap index out of bound");
		}
	}

	ref const(Pair!(K,V)) opIndex(K k) const @trusted {
		auto i = search(k);
		if(i != size_t.max) {
			return this.data[i];
		} else {
			throw new Exception("FashMap index out of bound");
		}
	}

	int opApply(int delegate(ref const K, ref V) dg) {
		int result = 0;
		foreach(ref it; this.data[0 .. this.len]) {
			result = dg(it.key, it.value);
			if(result) {
				break;
			}
		}
		
		return result;
	}
}

unittest {
	FashMap!(string,int) m;
	assert(m.insert("foo", 1));
	assert(m.length == 1);
	assert(m.contains("foo"));
	assert(m["foo"].value == 1);
	assert((cast(const)m)["foo"].value == 1);
	assert(m.insert("bar", 2));
	assert(m.contains("foo"));
	assert(m.contains("bar"));
	assert(m.length == 2);
	foreach(ref const string k, ref int v; m) {
		assert(k == "foo" || k == "bar");
		assert(v == 1 || v == 2);
	}
}
