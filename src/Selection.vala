public class HeadsUp.Selection {

	static bool is_wayland () {
		return "Wayland" in Gdk.Display.get_default ().get_name ();
	}

	public static string grab () throws Error {
		if (is_wayland ())
			return "";
		else
			return query_x11 ();
	}

	public static string query_x11 () throws Error {
		string stdout;
		GLib.Process.spawn_command_line_sync ("xsel --primary", out stdout);
		return stdout;
	}

	public static string query_wayland () {
		return ""; //TODO: Support Wayland
	}

}
