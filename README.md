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
