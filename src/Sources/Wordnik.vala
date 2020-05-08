public class HeadsUp.Sources.Wordnik : WebViewSource {

	public Wordnik () {
		Object (
			title: "Wordnik",
			icon: "document-properties-symbolic"
		);
	}

	public override string get_url () {
		return @"https://www.wordnik.com/words/$query";
	}

}
