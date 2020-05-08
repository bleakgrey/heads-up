using WebKit;

public class HeadsUp.Widgets.WebView : WebKit.WebView {

	public signal void on_ready ();

	public WebView () {
		var content = new WebKit.UserContentManager ();
		var settings = new WebKit.Settings ();
		settings.enable_javascript = false;
		settings.enable_developer_extras = true;

		Object (
			settings: settings,
			user_content_manager: content,
			hexpand: true,
			vexpand: true,
			visible: true
		);

		load_changed.connect (on_load_changed);

		var css = read_resource ("webview.css");
		var stylesheet = new UserStyleSheet (css,
				UserContentInjectedFrames.TOP_FRAME,
				UserStyleLevel.USER,
				null,
				null);
		user_content_manager.add_style_sheet (stylesheet);
	}

	void on_load_changed (LoadEvent ev) {
		switch (ev) {
			case LoadEvent.FINISHED:
				on_ready ();
				break;
			case LoadEvent.STARTED:
				break;
		}
	}

}
