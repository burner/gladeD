SRC=$(wildcard src/*.d)
all: $(SRC)
	dmd src/*.d -unittest -debug -g -ofgladed
	./gladed
