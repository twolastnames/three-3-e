TEMPLATE_PROJECT=three)(3
APPLICATION_NAME=three)(3
APPLICATION_DIR=app
BUNDLE_DIR=tmp/$(APPLICATION_NAME)
BROWSERIFY=./node_modules/.bin/browserify
BABEL_BIN=./node_modules/.bin/babel
BABEL=$(BABEL_BIN) --presets=es2015
EJS_CLI=./node_modules/.bin/ejs-cli
NODE=node
SHOW_TEMPLATE=build_helpers/show.ejs.es6
LIST_TEMPLATE=build_helpers/list.ejs.es6

PUSH_ARGS?=

.PHONEY: .all
all: deploy

$(BABEL_BIN):
	npm install babel

setup:
	npm install

.PHONEY: deploy
deploy: $(BUNDLE_DIR)/.couchappignore $(BUNDLE_DIR)/.couchapprc \
	bundle $(BUNDLE_DIR)/_attachments/index.html $(BUNDLE_DIR)/rewrites.json
#	mkdir -p '$(TEMPLATE_PROJECT)'
#	cd build && couchapp init
	cd '$(BUNDLE_DIR)' && couchapp push $(PUSH_ARGS) '$(PROJECT)'
#	make pretty-urls

$(BUNDLE_DIR)/.couchapp%: $(APPLICATION_DIR)/.couchapp%
	mkdir -p '$(@D)'
	cp '$(APPLICATION_DIR)/.couchapprc' '$(BUNDLE_DIR)/'
	cp '$(APPLICATION_DIR)/.couchappignore' '$(BUNDLE_DIR)/'

./node_modules/%:
	npm install $(notdir $@)

$(BUNDLE_DIR)/%.js: ./node_modules/%
	mkdir -p '$(@D)'
	$(BROWSERIFY) -r $(basename $(notdir $@)) > '$@'
	echo >> '$@'
	echo "module.exports = " \
	  "require('$(basename $(notdir $@))');" >> '$@'

.PHONEY: all-requires
all-requires:
	$(NODE) ./scripts/all_requires.js \
		| awk '{ print "$(BUNDLE_DIR)/"$$1".js" }' \
		| xargs make

$(BUNDLE_DIR)/views/%/map.js: $(APPLICATION_DIR)/views/%/map.js
	mkdir -p '$(@D)'
	cp '$<' '$@'

$(BUNDLE_DIR)/views/%/reduce.js: $(APPLICATION_DIR)/views/%/reduce.js
	mkdir -p '$(@D)'
	cp '$<' '$@'

$(BUNDLE_DIR)/views/lib/%.js: $(APPLICATION_DIR)/views/%.es6
	mkdir -p '$(@D)'
	cat '$<' | $(BABEL) > '$@'

$(BUNDLE_DIR)/template/list/%.ejs: $(APPLICATION_DIR)/lists/%.ejs
	mkdir -p '$(@D)'
	cat '$<' > '$@'

#$(BUNDLE_DIR)/list/%.js: $(APPLICATION_DIR)/lists/%.js
#	mkdir -p '$(@D)'
#	cp '$<' '$@'
$(BUNDLE_DIR)/template/base.ejs: $(APPLICATION_DIR)/template/base.ejs
	mkdir -p '$(@D)'
	cat '$<' > '$@'

$(BUNDLE_DIR)/_attachments/index.html:
	mkdir -p '$(@D)'
	elm package install
	find src/elm -type f | xargs elm make --output '$@' src/elm/Main.elm

$(BUNDLE_DIR)/template/show/%.ejs: $(APPLICATION_DIR)/shows/%.ejs
	mkdir -p '$(@D)'
	cat '$<' > '$@'

$(BUNDLE_DIR)/rewrites.json: $(APPLICATION_DIR)/rewrites.json
	mkdir -p '$(@D)'
	cat '$<' > '$@'

$(BUNDLE_DIR)/shows/%.js: $(APPLICATION_DIR)/shows/%.es6 \
	  $(APPLICATION_DIR)/shows/%.ejs ./node_modules/ejs-cli \
		$(SHOW_TEMPLATE) $(BUNDLE_DIR)/template/base.ejs
	make '$(BUNDLE_DIR)/template/show/$(basename $(@F)).ejs'
	mkdir -p '$(@D)'
	echo 'function(doc, req) {' > '$@'
	$(EJS_CLI) -O '{ "codeFilename" : "../$<", "showName" : "$(basename $(@F))" }' \
	   $(SHOW_TEMPLATE) | $(BABEL) >> '$@'
	echo '}' >> '$@'

$(BUNDLE_DIR)/lists/%.js: $(APPLICATION_DIR)/lists/%.es6 \
	  $(APPLICATION_DIR)/lists/%.ejs ./node_modules/ejs-cli \
		$(LIST_TEMPLATE) $(BUNDLE_DIR)/template/base.ejs
	make '$(BUNDLE_DIR)/template/list/$(basename $(@F)).ejs'
	mkdir -p '$(@D)'
	echo 'function(doc, req) {' > '$@'
	$(EJS_CLI) -O '{ "codeFilename" : "../$<", "listName" : "$(basename $(@F))" }' \
	   $(LIST_TEMPLATE) | $(BABEL) >> '$@'
	echo '}' >> '$@'

#tmp/three-3/shows/statement.js: $(APPLICATION_DIR)/shows/statement.js \
#	  $(APPLICATION_DIR)/shows/statement.ejs ./node_modules/ejs-cli
#	mkdir -p "$(dir $@)"
#	cp "$<" "$@"

#tmp/three-3/shows/statement.js: $(APPLICATION_DIR)/shows/statement.js
#	echo $@
#	echo $(BUNDLE_DIR)
#	mkdir -p "$(dir $@)"
#	cp "$<" "$@"

$(APPLICATION_DIR):
	echo "$(BUNDLE_DIR)"

.PHONEY: bundle
bundle:  all-requires
	cp $(APPLICATION_DIR)/.couch* "$(BUNDLE_DIR)/"
	find "$(APPLICATION_DIR)/views/" | grep -o "\/views\/.*\.js$$" | \
	  awk '{print "$(BUNDLE_DIR)"$$1}' | xargs -r make
	find "$(APPLICATION_DIR)/lists/" | grep -o "\/lists\/.*\.js$$" | \
	  awk '{print "$(BUNDLE_DIR)"$$1}' | xargs -r make
	find "$(APPLICATION_DIR)/shows/" | grep -o "\/shows\/.*\.es6$$" | \
	  awk '{print "$(BUNDLE_DIR)"$$1}' | sed s/.es6$$/.js/ | xargs -r make

tmp:
	mkdir -p tmp
	cp -rf lib tmp/

.PHONEY: couch_node_modules
couch_node_modules:
	node ./scripts/couch_node_modules.js | \
	  awk '{print "make", "\"$(BUNDLE_DIR)\"/" $$1 ".js"}' | bash

$(BUNDLE_DIR)/views/whens/map.js: app/views/whens/map.js
	mkdir -p "$(BUNDLE_DIR)/views/whens"
	cp app/.couch* "$(BUNDLE_DIR)/"
	echo 'function(doc) {' `$(BROWSERIFY) "$<"` "}" > "$@"
#	node scripts/all_packages.js | awk '{ print "-r", $$1}' | \
#	  xargs $(BROWSERIFY) -e "$<" #| echo > "$@"


clean:
	rm -rf tmp node_modules

.PHONEY: create-project-template
create-project-template:
	curl -X PUT 'http://127.0..1:5984/$(TEMPLATE_PROJECT)'

.PHONEY: delete-project-template
delete-project-template:
	curl -X DELETE 'http://127.0.0.1:5984/$(TEMPLATE_PROJECT)'

.PHONEY: create-project
create-project:
	curl -X PUT 'http://127.0.0.1:5984/$(PROJECT)'
	curl -X POST -H "Content-Type: application/json" -d '{"source":"$(TEMPLATE_PROJECT)","target":"$(PROJECT)"}' http://127.0.0.1:5984/_replicate

.PHONEY: delete-project
delete-project:
	curl -X DELETE http://127.0.0.1:5984/$(PROJECT)

.PHONEY: pretty-urls
pretty-urls:
	curl -X PUT -d '{"rewrites":[{"from":"thens","to":"_view/thens","method":"GET","query":"{}"}]}' 'http://127.0.0.1:5984/$(TEMPLATE_PROJECT)/_design/$(TEMPLATE_PROJECT)'

.PHONEY: example-view
example-view:
	curl 'http://127.0.0.1:5984/testdb/_design/$(TEMPLATE_PROJECT)/_view/steps'

DATE=`date`
time=$$(date +'%Y%m%d-%H%M%S')
createdoc:
	curl -X PUT http://127.0.0.1:5984/hello/$(time) -d '{"hello": "world", "random": "$(time)"}'

get:
	curl -X GET 'http://127.0.0.1:5984/testdb/20170106111920'


update:
	curl -X PUT 'http://127.0.0.1:5984/testdb/20170106111920' -d '{"_rev":"2-c6d4b0d4328e534eb8f3a30b59a724ef", "hello": "world", "random": "something better3"}'

#.PHONY test-seed
test-seed: #delete-project create-project
	cat test/import_gherkin.feature | ./scripts/import_gherkin.js $(PROJECT)
