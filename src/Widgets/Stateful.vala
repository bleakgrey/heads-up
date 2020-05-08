using Gtk;

[GtkTemplate (ui = "/stateful.ui")]
public class HeadsUp.Widgets.Stateful : Stack {

	[GtkChild]
	Box status;
	[GtkChild]
	Image status_image;
	[GtkChild]
	Label status_label;
	[GtkChild]
	Label status_desc;

	[GtkChild]
	public Box content;

	public void show_loading () {
		visible_child_name = "loading";
	}

	public void show_content () {
		visible_child = content;
	}

	public void show_status (string label, string desc, string icon = "dialog-warning-symbolic") {
		status_image.icon_name = icon;
		status_label.label = @"<span size=\"xx-large\">$label</span>";
		status_desc.label = desc;
		visible_child = status;
	}

}
