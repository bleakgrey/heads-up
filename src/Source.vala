using Gtk;
using Gee;

public class HeadsUp.Source : GLib.Object {

	/* Instantiated Object */

	public string title { get; construct set; }
	public string icon { get; construct set; }
	public Widget content {get; construct set; default = null; }
	public string query { get; set; }

	protected Widgets.Stateful stateful;

	public virtual void on_registered (Stack stack) {
		stateful = new Widgets.Stateful ();

		if (content == null)
			warning (@"Source $title has no content widget!");
		else
			stateful.content.pack_start (content, true, true);

		stack.add_titled (stateful, title, title);
		stack.child_set_property (stateful, "icon-name", icon);
	}

	public virtual bool on_lookup (string q) {
		stateful.show_status (_("Nothing Here"), _("Definition unavailable"));
		return true;
	}

	/* Static Registry */

	public static ArrayList<Source> registry = new ArrayList<Source> ();

	public static void register (Source source) {
		info (@"Adding new source: $(source.title)");
		registry.add (source);

		source.on_registered (app.window.source_stack);
	}

}
