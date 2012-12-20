# Generate files in build/, build/44x44, build/16x16 for each
# file in 100x100/

FILES100 := $(patsubst 100x100/%,build/%,$(wildcard 100x100/*.png))
FILES44 := $(patsubst 100x100/%,build/44x44/%,$(wildcard 100x100/*.png))
FILES32 := $(patsubst 100x100/%,build/32x32/%,$(wildcard 100x100/*.png))
FILES16 := $(patsubst 100x100/%,build/16x16/%,$(wildcard 100x100/*.png))

all: dobuild upload/last_updated

#updatesvn:
#	svn update

dobuild: build buildfiles

build:
	mkdir -p build build/44x44 build/16x16 build/32x32

buildfiles: $(FILES100) $(FILES44) $(FILES32) $(FILES16)

build/%.png: 100x100/%.png
	cp $< $@
	touch build/last_updated

build/44x44/%.png: 100x100/%.png
	convert -resize 44x44 $< $@

build/32x32/%.png: 100x100/%.png
	convert -resize 32x32 $< $@

build/16x16/%.png: 100x100/%.png
	convert -resize 16x16 $< $@

build/last_updated:
	touch $@

upload/last_updated: build/last_updated
	mkdir -p upload
	rsync -c --delete -r build/ upload/
	cp build/last_updated upload/last_updated
	rsync -rsh=ssh -av upload/ /var/www/xmltv/chanlogos/
        rsync -rsh=ssh -av upload/ /home/beatx/projects/tvtabla/htdocs/gfx/chanlogos/
