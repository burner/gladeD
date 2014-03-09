import somemodule;

import gtk.Main;

class MainWin : SomeClass {
	this() {
		super();
	}
}

void main(string[] args) {
	Main.initMultiThread(args);
	auto mw = new MainWin();
	Main.run();
}
