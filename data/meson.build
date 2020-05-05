asresources = gnome.compile_resources(
	'as-resources',
	'gresource.xml',
	c_name: 'as'
)

launcher = configure_file(
	input: 'launcher.desktop.in',
	output: '@BASENAME@',
	configuration: config,
)
i18n.merge_file(
    input: launcher,
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

appdata = configure_file(
	input: 'com.example.appdata.xml.in',
	output: '@BASENAME@',
	configuration: config,
)
i18n.merge_file(
    input: appdata,
    output: meson.project_name() + '.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'xml',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)
