SRC=$(wildcard src/*.d)
all: $(SRC)
	#dmd src/*.d -unittest -debug -g -ofgladed -version=XML_AA
	dmd src/*.d -unittest -debug -gc -ofgladed
	#./gladed

gdc: $(SRC)
	gdc src/*.d -unittest -ggdb -o gladed

ldc: $(SRC)
	ldc2 src/*.d -unittest -g -ofgladed

test:
	./gladed -i test1.glade -o mwin.d -m mwin -c MWin
	dmd outputtest.d mwin.d -L-ldl -ofoutput -I/usr/include/d/gtkd-3 -L-lgtkd-3
	./output

test2: $(all)
	./gladed -i test2.glade -o tbox.d -m tbox -c TBox
	dmd test2.d tbox.d -L-ldl -ofoutput2 -I/usr/include/d/gtkd-3 -L-lgtkd-3
	./output2

test3: $(all)
	#./gladed -i test3.glade -o tbox.d -m tbox -c TBox
	dmd tbox.d -L-ldl -ofoutput3 -I/usr/include/d/gtkd-3 -L-lgtkd-3
	./output3

valgrind: $(gdc)
	valgrind --tool=callgrind ./gladed -i test1.glade -o mwin.d -m mwin -c MWin
