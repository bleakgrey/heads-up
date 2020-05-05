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
	Stack stack;

	[GtkChild]
	Box state;
	[GtkChild]
	Image state_image;
	[GtkChild]
	Label state_label;
	[GtkChild]
	Label state_desc;
	[GtkChild]
	Spinner loading;
	[GtkChild]
	Box content;

	HeadsUp.WebView webview;

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

		webview = new WebView ();
		webview.on_ready.connect (() => {
			stack.visible_child = content;
		});
		content.add (webview);
	}

	void update_state (string icon, string label, string desc) {
		header.title = "";
		header.subtitle = "";
		state_image.icon_name = icon;
		state_label.label = @"<span size=\"xx-large\">$label</span>";
		state_desc.label = desc;
		stack.visible_child = state;
	}

	public void empty_state () {
		update_state ("edit-find-symbolic",
					_("No text selected"),
					_("Select something in any window to search for its definition"));
	}

	public void look_up (string q) {
		query = q;
		header.title = @"\"$query\"";
		header.subtitle = _("provided by Wikitionary (CC BY-SA 3.0)");
		on_lang_changed ();
	}

	void reload_webview () {
		stack.visible_child = loading;
		webview.load_uri (@"https://$lang.wiktionary.org/w/index.php?printable=yes&redirects=1&title=$query");
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
				reload_webview ();
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
