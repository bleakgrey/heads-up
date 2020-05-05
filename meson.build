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
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

sources = [
	'Config.vala',
	'Application.vala',
	'Window.vala',
	'WebView.vala',
	'Selection.vala',
]

configured_sources = []

foreach i : sources
	file = configure_file(
		input: 'src/' + i,
		output: i,
		configuration: config
	)
	configured_sources += file
endforeach

subdir('data')
subdir('po')

executable(
    meson.project_name(),
    asresources,
    configured_sources,
    dependencies: [
        dependency('gtk+-3.0', version: '>=3.22.0'),
        dependency('webkit2gtk-4.0'),
    ],
    install: true,
)

meson.add_install_script('meson/post_install.py')
