using Gtk;

namespace HeadsUp {

	public App? app;

	public class App : Gtk.Application {

		public Window? window;

		public App () {
			Object(
				application_id: Config.ID,
				flags: ApplicationFlags.FLAGS_NONE
			);
		}

		protected override void activate () {
			if (window == null) {
				window = new Window ();
				add_window (window);
			}
			window.present ();

			Source.register (new Sources.Wikitionary ());

			var query = Selection.grab ();
			query = "heads-up";
			if (query != "")
				window.look_up (query);
			else
				window.empty_state ();
		}

		public static int main (string[] args) {
			Hdy.init (ref args);
			app = new App ();
			return app.run (args);
		}
	}

	static string read_resource (string name) throws Error {
		var res = GLib.resources_lookup_data (@"/$name", ResourceLookupFlags.NONE);
		return (string) res.get_data ();
	}

}
