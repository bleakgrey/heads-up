public class HeadsUp.Sources.Wikitionary : WebViewSource {

	public Wikitionary () {
		Object (
			title: "Wikitionary",
			icon: "document-properties-symbolic"
		);
	}

	public override string get_url () {
		return @"https://$(app.window.lang).wiktionary.org/w/index.php?printable=yes&redirects=1&title=$query";
	}

}
