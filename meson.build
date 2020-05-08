project('com.github.bleakgrey.headsup', 'vala', 'c', version: '1.0.0')

gnome = import('gnome')
i18n = import('i18n')

config = configuration_data()
config.set('EXEC_NAME', meson.project_name())
config.set('RES_DOMAIN', '/' + '/'.join(meson.project_name().split('.')) )
config.set('NAME', meson.project_name())
config.set('GETTEXT_PACKAGE', meson.project_name())
config.set('VERSION', meson.project_version())
config.set('PREFIX', get_option('prefix'))

add_global_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
        '-DHANDY_USE_UNSTABLE_API',
    ],
    language: 'c',
)

config_class = configure_file(
	input: 'src/Config.vala',
	output: 'Config.vala',
	configuration: config
)

sources = [
	config_class,
	'src/Application.vala',
	'src/Window.vala',
	'src/Widgets/Stateful.vala',
	'src/Widgets/WebView.vala',
	'src/Selection.vala',
	'src/Source.vala',
	'src/WebViewSource.vala',
	'src/Sources/Wikitionary.vala',
	'src/Sources/Wordnik.vala',
]

subdir('data')
subdir('po')

executable(
    meson.project_name(),
    asresources,
    sources,
    dependencies: [
        dependency('gtk+-3.0', version: '>=3.22.0'),
        dependency('gee-0.8'),
        dependency('webkit2gtk-4.0'),
        dependency('libhandy-0.0'),
    ],
    install: true,
)

meson.add_install_script('meson/post_install.py')
