using Gtk;

[GtkTemplate (ui = "/window.ui")]
public class HeadsUp.Window : Gtk.Window {

	Gtk.Settings settings;
	GLib.Settings lang_settings;
	CssProvider provider;

	public string lang { get; set; default = "en"; }
	public string? query { get; set; default = null; }

	[GtkChild]
	HeaderBar header;

	[GtkChild]
	Widgets.Stateful stateful;
	[GtkChild]
	Hdy.ViewSwitcherBar switcher;

	public Stack source_stack;

	construct {
		source_stack = new Gtk.Stack ();
		source_stack.vexpand = source_stack.hexpand = true;
		source_stack.show ();
		stateful.content.pack_start (source_stack);

		switcher.stack = source_stack;
	}

	public Window () {
		Object ();

		var locale = GLib.Environment.get_variable ("LANG");
		if (locale != null)
			lang = locale.split ("_")[0];

		provider = new CssProvider ();
		provider.load_from_resource ("/theme_mixin.css");

		settings = Gtk.Settings.get_default ();
		settings.notify["gtk-theme-name"].connect (() => on_theme_changed ());
		settings.notify["gtk-application-prefer-dark-theme"].connect (() => on_theme_changed ());
		on_theme_changed ();

		lang_settings = new GLib.Settings ("org.gnome.desktop.input-sources");
		lang_settings.changed["current"].connect (() => on_lang_changed ());
		lang_settings.changed["mru-sources"].connect (() => on_lang_changed ());
	}

	public void no_selection () {
		header.title = "";
		header.subtitle = "";
		switcher.reveal = false;
		stateful.show_status (_("No Selection"),
							 _("Select something in any window to search for its definition"),
							 "edit-find-symbolic");
	}

	public void no_sources () {
		header.title = "";
		header.subtitle = "";
		switcher.reveal = false;
		stateful.show_status (_("No Sources"),
							 _("You don't have any lookup sources available"),
							 "edit-find-symbolic");
	}

	public void look_up (string q) {
		query = q;
		header.title = @"\"$query\"";
		switcher.reveal = true;
		stateful.show_content ();
		on_lang_changed ();

		Source.registry.@foreach (s => s.on_lookup (q));
	}

	void on_theme_changed () {
		var theme = settings.gtk_theme_name;
		var ctx = get_style_context ();
		ctx.remove_class ("dark");

		if ("Adwaita" in theme || "elementary" in theme) {
			StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, STYLE_PROVIDER_PRIORITY_APPLICATION);
			if (settings.gtk_application_prefer_dark_theme)
				ctx.add_class ("dark");
		}
		else {
			StyleContext.remove_provider_for_screen (Gdk.Screen.get_default (), provider);
		}
	}

	void on_lang_changed () {
		var sources = lang_settings.get_value ("mru-sources");
		var current = lang_settings.get_uint ("current");
		string mgr;
		string source;

		var i = 0;
		var iter = sources.iterator ();
		while (iter.next ("(ss)", out mgr, out source)) {
			if (i == current && query != null) {
				lang = patch_lang_source (source);
				// reload_webview ();
			}
			i++;
		}
	}

	string patch_lang_source (string s) {
		switch (s) {
			case "us":
				return "en";
			default:
				return s;
		}
	}

}
