# useful project directories
root := justfile_directory()
docs := root / 'docs'
tests := root / 'tests'
assets := root / 'assets'
template := root / 'template'

# install/uninstall specific variables
data :=  data_directory() / 'typst' / 'packages'
namespace := 'preview'
version := '0.1.0'
name := 'chiral-thesis-fhe'
spec := '@' + namespace + '/' + name + ':' + version

# typst envs for easy development
export TYPST_ROOT := root
export TYPST_FONT_PATHS := assets / 'fonts'

alias tt := typst-test

[private]
@default:
	just --list --unsorted

# run typst-test with the required environment variables
typst-test *args:
	typst-test {{ args }}

# compile and optimize assets
assets:
	typst compile \
		{{ assets / 'images' / 'draft-watermark.typ' }} \
		{{ assets / 'images' / 'draft-watermark.svg' }}
	oxipng --opt max --recursive {{ assets / 'images' }}

# compile the manual and exmaples
doc: install
	typst compile {{ docs / 'manual.typ' }} {{ docs / 'manual.pdf' }}
	rm -rf {{ assets / 'tmp' }}
	mkdir {{ assets / 'tmp' }}
	typst compile \
		--root {{ template }} \
		{{ template / 'main.typ' }} \
		{{ assets / 'tmp' / '{n}.png' }}
	mv {{ assets / 'tmp' / '1.png' }} {{ assets / 'images' / 'thumbnail.png' }}
	rm -rf {{ assets / 'tmp' }}
	oxipng --opt max {{ assets / 'images' / 'thumbnail.png' }}

# test the scaffolding
test-scaffold: install && uninstall
	rm -rf {{ tests / 'template' }}
	typst init {{ spec }} {{ tests / 'template' }}

# run the complete test suite
test *args: (typst-test "run" args) test-scaffold

# update the given tests
update *args: (typst-test "update" args)

# install the package locally
install: uninstall
	mkdir -p {{ data / namespace / name }}
	ln -s {{ root }} {{ data / namespace / name / version }}

# uninstall the package locally
uninstall:
	rm -rf {{ data / namespace / name / version }}

# uninstall all versions of the package locally
purge:
	rm -rf {{ data / namespace / name }}
