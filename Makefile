# Generate files in build/, build/44x44, build/16x16 for each
# file in 100x100/

FILES100 := $(patsubst 100x100/%,build/%,$(wildcard 100x100/*.png))
FILES44 := $(patsubst 100x100/%,build/44x44/%,$(wildcard 100x100/*.png))
FILES16 := $(patsubst 100x100/%,build/16x16/%,$(wildcard 100x100/*.png))

all: updatesvn dobuild upload/last_updated

updatesvn:
	svn update

dobuild: build buildfiles

build:
	mkdir -p build build/44x44 build/16x16

buildfiles: $(FILES100) $(FILES44) $(FILES16)

build/%.png: 100x100/%.png
	cp $< $@
	touch build/last_updated

build/44x44/%.png: 100x100/%.png
	convert -resize 44x44 $< $@

build/16x16/%.png: 100x100/%.png
	convert -resize 16x16 $< $@

build/last_updated:
	touch $@

upload/last_updated: build/last_updated
	mkdir -p upload
	rsync -c --delete -r build/ upload/
	HOME=/var/local/nonametv sitecopy -r /var/local/nonametv/sitecopyrc --update logos.swedb.se
	rsync -av upload/ acheron.geijersson.com:public_html/chanlogos/
	rsync -av upload/ fiorina161.geijersson.com:public_html/chanlogos/
	cp build/last_updated upload/last_updated
