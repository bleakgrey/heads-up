public class HeadsUp.WebViewSource : Source {

	Widgets.WebView webview;

	construct {
		webview = new Widgets.WebView ();
		webview.on_ready.connect (() => {
			stateful.show_content ();
		});
		content = webview;
	}

	public override bool on_lookup (string q) {
		query = q;
		reload ();
		return true;
	}

	public virtual string get_url () {
		return "";
	}

	void reload () {
		stateful.show_loading ();
		webview.load_uri (get_url ());
	}

}
