import somemodule;

import gtk.Main;

class MainWin : SomeClass {
	this() {
		super();
	}

	override void quitMenuEntryHandler(MenuItem) {
		Main.quit();
	}
}

void main(string[] args) {
	Main.initMultiThread(args);
	auto mw = new MainWin();
	Main.run();
}
