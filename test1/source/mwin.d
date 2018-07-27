module mwin;

public import gtk.AccelLabel;
public import gtk.Box;
public import gtk.Button;
public import gtk.Entry;
public import gtk.ImageMenuItem;
public import gtk.Label;
public import gtk.Menu;
public import gtk.MenuBar;
public import gtk.MenuItem;
public import gtk.Notebook;
public import gtk.SeparatorMenuItem;
import gtk.Window;
import gtk.Builder;
import std.stdio;

abstract class MWin : Window {
	string __gladeString = `<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated with glade 3.22.1 -->
<interface>
  <requires lib="gtk+" version="3.10"/>
  <object class="GtkWindow" id="window1">
    <property name="can_focus">False</property>
    <child>
      <placeholder/>
    </child>
    <child>
      <object class="GtkBox" id="box1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkMenuBar" id="menubar1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkMenuItem" id="menuitem1">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_File</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="menu1">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem1">
                        <property name="label">gtk-new</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem2">
                        <property name="label">gtk-open</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem3">
                        <property name="label">gtk-save</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem4">
                        <property name="label">gtk-save-as</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkSeparatorMenuItem" id="separatormenuitem1">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="quitMenuEntry">
                        <property name="label">gtk-quit</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
            <child>
              <object class="GtkMenuItem" id="menuitem2">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_Edit</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="menu2">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem6">
                        <property name="label">gtk-cut</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem7">
                        <property name="label">gtk-copy</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem8">
                        <property name="label">gtk-paste</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem9">
                        <property name="label">gtk-delete</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
            <child>
              <object class="GtkMenuItem" id="menuitem3">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_View</property>
                <property name="use_underline">True</property>
              </object>
            </child>
            <child>
              <object class="GtkMenuItem" id="menuitem4">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_Help</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="menu3">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <child>
                      <object class="GtkImageMenuItem" id="imagemenuitem10">
                        <property name="label">gtk-about</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">0</property>
          </packing>
        </child>
        <child>
          <object class="GtkButton" id="button1">
            <property name="label" translatable="yes">button</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="receives_default">True</property>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkNotebook" id="notebook1">
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <child>
              <object class="GtkButton" id="button2">
                <property name="label" translatable="yes">button</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="receives_default">True</property>
              </object>
            </child>
            <child type="tab">
              <object class="GtkLabel" id="label1">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">page 1</property>
              </object>
              <packing>
                <property name="tab_fill">False</property>
              </packing>
            </child>
            <child>
              <object class="GtkEntry" id="entry1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
              </object>
              <packing>
                <property name="position">1</property>
              </packing>
            </child>
            <child type="tab">
              <object class="GtkLabel" id="label2">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">page 2</property>
              </object>
              <packing>
                <property name="position">1</property>
                <property name="tab_fill">False</property>
              </packing>
            </child>
            <child>
              <object class="GtkAccelLabel" id="accellabel1">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">label</property>
              </object>
              <packing>
                <property name="position">2</property>
              </packing>
            </child>
            <child type="tab">
              <object class="GtkLabel" id="label3">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">page 3</property>
              </object>
              <packing>
                <property name="position">2</property>
                <property name="tab_fill">False</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">True</property>
            <property name="fill">True</property>
            <property name="position">2</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
</interface>
`;
	Builder __superSecretBuilder;
	Window window1;
	Box box1;
	MenuBar menubar1;
	MenuItem menuitem1;
	Menu menu1;
	ImageMenuItem imagemenuitem1;
	ImageMenuItem imagemenuitem2;
	ImageMenuItem imagemenuitem3;
	ImageMenuItem imagemenuitem4;
	SeparatorMenuItem separatormenuitem1;
	ImageMenuItem quitMenuEntry;
	MenuItem menuitem2;
	Menu menu2;
	ImageMenuItem imagemenuitem6;
	ImageMenuItem imagemenuitem7;
	ImageMenuItem imagemenuitem8;
	ImageMenuItem imagemenuitem9;
	MenuItem menuitem3;
	MenuItem menuitem4;
	Menu menu3;
	ImageMenuItem imagemenuitem10;
	Button button1;
	Notebook notebook1;
	Button button2;
	Label label1;
	Entry entry1;
	Label label2;
	AccelLabel accellabel1;
	Label label3;

	this() {
		super("");
		__superSecretBuilder = new Builder();
		__superSecretBuilder.addFromString(__gladeString);
		this.window1 = cast(Window)__superSecretBuilder.getObject("window1");
		this.box1 = cast(Box)__superSecretBuilder.getObject("box1");
		this.box1.reparent(this);
		this.add(box1);
		this.menubar1 = cast(MenuBar)__superSecretBuilder.getObject("menubar1");
		this.menuitem1 = cast(MenuItem)__superSecretBuilder.getObject("menuitem1");
		this.menu1 = cast(Menu)__superSecretBuilder.getObject("menu1");
		this.imagemenuitem1 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem1");
		this.imagemenuitem2 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem2");
		this.imagemenuitem3 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem3");
		this.imagemenuitem4 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem4");
		this.separatormenuitem1 = cast(SeparatorMenuItem)__superSecretBuilder.getObject("separatormenuitem1");
		this.quitMenuEntry = cast(ImageMenuItem)__superSecretBuilder.getObject("quitMenuEntry");
		this.menuitem2 = cast(MenuItem)__superSecretBuilder.getObject("menuitem2");
		this.menu2 = cast(Menu)__superSecretBuilder.getObject("menu2");
		this.imagemenuitem6 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem6");
		this.imagemenuitem7 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem7");
		this.imagemenuitem8 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem8");
		this.imagemenuitem9 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem9");
		this.menuitem3 = cast(MenuItem)__superSecretBuilder.getObject("menuitem3");
		this.menuitem4 = cast(MenuItem)__superSecretBuilder.getObject("menuitem4");
		this.menu3 = cast(Menu)__superSecretBuilder.getObject("menu3");
		this.imagemenuitem10 = cast(ImageMenuItem)__superSecretBuilder.getObject("imagemenuitem10");
		this.button1 = cast(Button)__superSecretBuilder.getObject("button1");
		this.notebook1 = cast(Notebook)__superSecretBuilder.getObject("notebook1");
		this.button2 = cast(Button)__superSecretBuilder.getObject("button2");
		this.label1 = cast(Label)__superSecretBuilder.getObject("label1");
		this.entry1 = cast(Entry)__superSecretBuilder.getObject("entry1");
		this.label2 = cast(Label)__superSecretBuilder.getObject("label2");
		this.accellabel1 = cast(AccelLabel)__superSecretBuilder.getObject("accellabel1");
		this.label3 = cast(Label)__superSecretBuilder.getObject("label3");
		this.menuitem1.addOnActivate(&this.menuitem1Dele);
		this.imagemenuitem1.addOnActivate(&this.imagemenuitem1Dele);
		this.imagemenuitem2.addOnActivate(&this.imagemenuitem2Dele);
		this.imagemenuitem3.addOnActivate(&this.imagemenuitem3Dele);
		this.imagemenuitem4.addOnActivate(&this.imagemenuitem4Dele);
		this.quitMenuEntry.addOnActivate(&this.quitMenuEntryDele);
		this.menuitem2.addOnActivate(&this.menuitem2Dele);
		this.imagemenuitem6.addOnActivate(&this.imagemenuitem6Dele);
		this.imagemenuitem7.addOnActivate(&this.imagemenuitem7Dele);
		this.imagemenuitem8.addOnActivate(&this.imagemenuitem8Dele);
		this.imagemenuitem9.addOnActivate(&this.imagemenuitem9Dele);
		this.menuitem3.addOnActivate(&this.menuitem3Dele);
		this.menuitem4.addOnActivate(&this.menuitem4Dele);
		this.imagemenuitem10.addOnActivate(&this.imagemenuitem10Dele);
		this.button1.addOnClicked(&this.button1Dele);
		this.button2.addOnClicked(&this.button2Dele);
		showAll();
	}

	void menuitem1Dele(MenuItem sig) {
		menuitem1Handler(sig);
	}

	void menuitem1Handler(MenuItem sig) {
		writeln("menuitem1HandlerStub");
	}

	void imagemenuitem1Dele(MenuItem sig) {
		imagemenuitem1Handler(sig);
	}

	void imagemenuitem1Handler(MenuItem sig) {
		writeln("imagemenuitem1HandlerStub");
	}

	void imagemenuitem2Dele(MenuItem sig) {
		imagemenuitem2Handler(sig);
	}

	void imagemenuitem2Handler(MenuItem sig) {
		writeln("imagemenuitem2HandlerStub");
	}

	void imagemenuitem3Dele(MenuItem sig) {
		imagemenuitem3Handler(sig);
	}

	void imagemenuitem3Handler(MenuItem sig) {
		writeln("imagemenuitem3HandlerStub");
	}

	void imagemenuitem4Dele(MenuItem sig) {
		imagemenuitem4Handler(sig);
	}

	void imagemenuitem4Handler(MenuItem sig) {
		writeln("imagemenuitem4HandlerStub");
	}

	void quitMenuEntryDele(MenuItem sig) {
		quitMenuEntryHandler(sig);
	}

	void quitMenuEntryHandler(MenuItem sig) {
		writeln("quitMenuEntryHandlerStub");
	}

	void menuitem2Dele(MenuItem sig) {
		menuitem2Handler(sig);
	}

	void menuitem2Handler(MenuItem sig) {
		writeln("menuitem2HandlerStub");
	}

	void imagemenuitem6Dele(MenuItem sig) {
		imagemenuitem6Handler(sig);
	}

	void imagemenuitem6Handler(MenuItem sig) {
		writeln("imagemenuitem6HandlerStub");
	}

	void imagemenuitem7Dele(MenuItem sig) {
		imagemenuitem7Handler(sig);
	}

	void imagemenuitem7Handler(MenuItem sig) {
		writeln("imagemenuitem7HandlerStub");
	}

	void imagemenuitem8Dele(MenuItem sig) {
		imagemenuitem8Handler(sig);
	}

	void imagemenuitem8Handler(MenuItem sig) {
		writeln("imagemenuitem8HandlerStub");
	}

	void imagemenuitem9Dele(MenuItem sig) {
		imagemenuitem9Handler(sig);
	}

	void imagemenuitem9Handler(MenuItem sig) {
		writeln("imagemenuitem9HandlerStub");
	}

	void menuitem3Dele(MenuItem sig) {
		menuitem3Handler(sig);
	}

	void menuitem3Handler(MenuItem sig) {
		writeln("menuitem3HandlerStub");
	}

	void menuitem4Dele(MenuItem sig) {
		menuitem4Handler(sig);
	}

	void menuitem4Handler(MenuItem sig) {
		writeln("menuitem4HandlerStub");
	}

	void imagemenuitem10Dele(MenuItem sig) {
		imagemenuitem10Handler(sig);
	}

	void imagemenuitem10Handler(MenuItem sig) {
		writeln("imagemenuitem10HandlerStub");
	}

	void button1Dele(Button sig) {
		button1Handler(sig);
	}

	void button1Handler(Button sig) {
		writeln("button1HandlerStub");
	}

	void button2Dele(Button sig) {
		button2Handler(sig);
	}

	void button2Handler(Button sig) {
		writeln("button2HandlerStub");
	}
}
