using Gtk;
using Gee;

public class HeadsUp.Source : GLib.Object {

	/* Instantiated Object */

	public string title { get; construct set; }
	public string icon { get; construct set; }
	public Widget content {get; construct set; default = null; }

	public Source () {

	}

	public virtual void on_selected () {
		if (content == null) {
			warning (@"$title has no content widget!");
			return;
		}


	}

	public virtual void on_registered (Stack stack) {
		var custom_content = new Box (Orientation.VERTICAL, 0);
		stack.add_titled (custom_content, title, title);
		stack.child_set_property (custom_content, "icon-name", icon);
		custom_content.show ();
	}



	/* Static Registry */

	protected static ArrayList<Source> registry = new ArrayList<Source> ();

	public static void register (Source source) {
		info (@"Adding new source: $(source.title)");
		registry.add (source);

		source.on_registered (app.window.source_stack);
	}

}
