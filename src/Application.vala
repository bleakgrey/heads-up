using Gtk;

namespace HeadsUp {

	public class App : Gtk.Application {

		Window? window;

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

			var query = Selection.grab ();
			if (query != "")
				window.look_up (query);
			else
				window.empty_state ();
		}

		  public static int main (string[] args) {
			return new App ().run (args);
		  }
	}

	static string read_resource (string name) throws Error {
		var res = GLib.resources_lookup_data (@"/$name", ResourceLookupFlags.NONE);
		return (string) res.get_data ();
	}

}
