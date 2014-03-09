SRC=$(wildcard src/*.d)
all: $(SRC)
	#dmd src/*.d -unittest -debug -g -ofgladed -version=XML_AA
	dmd src/*.d -unittest -debug -g -ofgladed
	./gladed

test:
	dmd output.d outputtest.d -I/usr/local/include/d/gtkd-2/ -L/usr/local/lib/libgtkd-2.a -L-ldl
	./output
