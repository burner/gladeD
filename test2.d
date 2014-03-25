import tbox;

import gtk.Main;
import gtk.Window;

class TBoxImpl : TBox {
	this() {
		super();
	}
}

void main(string[] args) {
	Main.initMultiThread(args);
	auto mw = new Window("tbox");
	mw.add(new TBoxImpl());
	mw.show();
	Main.run();
}
