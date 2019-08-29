## Build file for meson

project('bindbc-physfs', 'd',
	meson_version: '>=0.46.0',
	license: 'Boost',
	version: '0.0.1',
	subproject_dir: 'subprojects',
	default_options: [
		'buildtype=release',
		],
	)

compiler_id		= meson.get_compiler('d').get_id()
project_name		= meson.project_name()
project_target		= project_name + '_' + compiler_id
project_description	= 'A dynamic binding to the Physfs library.'
project_homepage	= 'https://github.com/W-joe/bindbc-physfs'


## versions
physfs_version = get_option('physfs_version')
module_versions = physfs_version


## Dependencies
bindbc_loader_dep = dependency('bindbc-loader_' + compiler_id,
	required: false,
	version: '>=0.2.0')

if not bindbc_loader_dep.found()
	bindbc_loader = subproject('bindbc-loader')
	bindbc_loader_dep = bindbc_loader.get_variable('bindbc_loader_dep')
endif


## Import directories
import_dir = include_directories(
	'source/',
	)


## Source Files
source_files = [
	'source/bindbc/physfs/config.d',
	'source/bindbc/physfs/dynload.d',
	'source/bindbc/physfs/package.d',

	'source/bindbc/physfs/bind/package.d',
	'source/bindbc/physfs/bind/physfs.d',
	]


## Target
target_lib = library(
	project_target,
	sources: source_files,
	include_directories: import_dir,
	dependencies: [bindbc_loader_dep],
	install: true,
	d_module_versions: module_versions,
	pic: true,
	)

install_subdir('source/bindbc/', install_dir: 'include/d/')


## Dependency
bindbc_physfs_dep = declare_dependency(
	include_directories: import_dir,
	link_with: target_lib,
	version: meson.project_version(),
	dependencies: bindbc_loader_dep,
	)


## pkg-config
pkgConf = import('pkgconfig')
pkgConf.generate(
	name: project_target,
	subdirs: 'd/',
	version: meson.project_version(),
	description: project_description,
	d_module_versions: module_versions,
	libraries: target_lib,
	)

