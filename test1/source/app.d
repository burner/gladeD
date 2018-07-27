import gtk.Main;
import outputtest;

void main(string[] args) {
	Main.initMultiThread(args);
	auto mw = new MainWin();
	Main.run();
}
