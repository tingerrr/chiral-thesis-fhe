docs := 'docs'
manual := docs / 'manual'

assets := 'assets'
fonts := assets / 'fonts'
images := assets / 'images'
template := assets / 'template'
thumbnail := images / 'thumbnail'
watermark := images / 'watermark'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := fonts

# list recipes
[private]
default:
	@just --list --unsorted

# run tytanic with the correct assets
[positional-arguments]
tt *args:
	@tt "$@"

# run the full test suite
test:
	tt run --no-fail-fast --expression 'all()'

# update all persistent assets
update: update-manual update-thumbnail update-watermark

# generate all non-persistent assets
generate: generate-manual generate-thumbnail generate-watermark

# clean all output directories
clean:
	rm --recursive --force {{ manual / 'out' }}
	rm --recursive --force {{ thumbnail / 'out' }}
	rm --recursive --force {{ watermark / 'out' }}
	tt util clean

# run the ci checks locally
ci: generate test

# update the draft watermark
update-watermark: generate-watermark
	cp {{ watermark / 'out' / 'watermark.svg' }} {{ images / 'watermark.svg' }}

# generate the draft watermark
generate-watermark: (clear-directory (watermark / 'out'))
	typst compile \
		{{ watermark / 'watermark.typ' }} \
		{{ watermark / 'out' / 'watermark.svg' }}

# update the template thumbnail
update-thumbnail: generate-thumbnail
	cp {{ thumbnail / 'out' / 'thumbnail.png' }} {{ images / 'thumbnail.png' }}
	oxipng --opt max {{ thumbnail / 'out' / 'thumbnail.png' }}

# generate the template thumbnail
generate-thumbnail: (clear-directory (thumbnail / 'out'))
	typst compile \
		--ppi 300 \
		{{ thumbnail / 'thumbnail.typ' }} \
		{{ thumbnail / 'out' / 'thumbnail.png' }}

# generate a new manual and update it
update-manual: generate-manual
	cp {{ manual / 'out' / 'manual.pdf' }} {{ assets / 'manual.pdf' }}

# generate the manual
generate-manual: (clear-directory (manual / 'out'))
	typst compile \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

# watch the manual
watch-manual: (clear-directory (manual / 'out'))
	typst watch \
		{{ manual / 'manual.typ' }} \
		{{ manual / 'out' / 'manual.pdf' }}

[private]
clear-directory dir:
	rm --recursive --force {{ dir }}
	mkdir {{ dir }}
