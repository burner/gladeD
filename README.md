gladeD
======

gladeD takes Gtk glade files and creates a D class out of them. The created
class will inherit from the main widget of the glade file. Default handler for
click and activate actions are created and connected. The created class can
than be inherited and default action handler be overwritten. The handler are
of the following schema. [NAME_OF_WIDGET]Handler([WIDGETTYPE);

To get a feel for the created class, run the test target of the makefile and
inspect the created file output.d.

Example
-------
The following code shows how to use the CREATED_CLASS and how to override the
handler for the quit menu entry in the file menu.

```d
import CREATED_MODULE_CONTAINING_CREATED_CLASS;

class MainWin : CREATED_CLASS {
	this() {
		super();
	}

	override void quitMenuEntryHandler(MenuItem) {
		this.destroy();
		Main.quit();
	}
}
```

Usage
-----
Running gladed --help should make things clear

Known Bugs
----------
Properly many, feel free to add issues on github or to send pull request. It
is only tested on Arch Linux x32/x64 with DMD 2.065 and gdc 2.064.

License
-------
GPL3
