import mwin;

import gtk.Main;

class MainWin : MWin {
	this() {
		super();
	}

	override void quitMenuEntryHandler(MenuItem) {
		this.destroy();
		Main.quit();
	}
}
