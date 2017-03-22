
TEMPLATE_PROJECT='template-project$$'

deploy:
	mkdir -p $(TEMPLATE_PROJECT)
#	cd build && couchapp init
	cd $(TEMPLATE_PROJECT) && couchapp push hello

create-project-template:
	curl -X PUT 'http://127.0.0.1:5984/$(TEMPLATE_PROJECT)'

delete-project-template:
	curl -X DELETE 'http://127.0.0.1:5984/$(TEMPLATE_PROJECT)'

create-project:
	curl -X PUT 'http://127.0.0.1:5984/$(PROJECT)'
	curl -X POST -H "Content-Type: application/json" -d '{"source":"$(TEMPLATE_PROJECT)","target":"$(PROJECT)"}' http://127.0.0.1:5984/_replicate

delete-project:
	curl -X DELETE http://127.0.0.1:5984/$(PROJECT)

createdb:
	curl -X PUT http://127.0.0.1:5984/testdb

deletedb:
	curl -X DELETE http://127.0.0.1:5984/testdb

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
