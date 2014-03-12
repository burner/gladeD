SRC=$(wildcard src/*.d)
all: $(SRC)
	#dmd src/*.d -unittest -debug -g -ofgladed -version=XML_AA
	dmd src/*.d -unittest -debug -gc -ofgladed
	#./gladed

gdc: $(SRC)
	gdc src/*.d -unittest -ggdb -o gladed

test: $(all)
	./gladed -i test1.glade -o mwin.d -m mwin -c MWin
	dmd outputtest.d mwin.d -I/usr/local/include/d/gtkd-2/ \
		-L/usr/local/lib/libgtkd-2.a -L-ldl -ofoutput
	./output
