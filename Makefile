
#TEMPLATE_PROJECT='template-project$$'
TEMPLATE_PROJECT=three)(3
APPLICATION_NAME=three)(3
APPLICATION_DIR=app
BUNDLE_DIR=tmp/$(APPLICATION_NAME)

PUSH_ARGS?=

.PHONEY: deploy
deploy:
#	mkdir -p '$(TEMPLATE_PROJECT)'
#	cd build && couchapp init
	cd '$(APP_NAME)' && couchapp push $(PUSH_ARGS) '$(TEMPLATE_PROJECT)'
#	make pretty-urls

SOMEPLACE?=testdb
.PHONEY: deploy
deploy-someplace:
	mkdir -p '$(TEMPLATE_PROJECT)'
#	cd build && couchapp init
	cd '$(TEMPLATE_PROJECT)' && couchapp push $(PUSH_ARGS) '$(SOMEPLACE)'
#	make pretty-urls

bundle: "tmp/$(TEMPLATE_"
	


.PHONEY: create-project-template
create-project-template:
	curl -X PUT 'http://127.0.0.1:5984/$(TEMPLATE_PROJECT)'

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
	curl 'http://127.0.0.1:5984/testdb/_design/$(TEMPLATE_PROJECT)/_view/statements'

DATE=`date`
time=$$(date +'%Y%m%d-%H%M%S')
createdoc:
	curl -X PUT http://127.0.0.1:5984/hello/$(time) -d '{"hello": "world", "random": "$(time)"}'

get:
	curl -X GET 'http://127.0.0.1:5984/testdb/20170106111920'


update:
	curl -X PUT 'http://127.0.0.1:5984/testdb/20170106111920' -d '{"_rev":"2-c6d4b0d4328e534eb8f3a30b59a724ef", "hello": "world", "random": "something better3"}'

#.PHONY test-seed
test-seed: delete-project create-project
	cat test/import_gherkin.feature | ./scripts/import_gherkin.js $(PROJECT)
