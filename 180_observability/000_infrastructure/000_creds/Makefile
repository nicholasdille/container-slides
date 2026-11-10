EVENT_NAME := 20261119
SEAT_COUNT := 11
DOMAIN     := inmylab.de

clean:
	@rm -f seats.json passwords.csv

seats.json:
	@EVENT_NAME=$(EVENT_NAME) SEAT_COUNT=$(SEAT_COUNT) DOMAIN=$(DOMAIN) bash generate.sh

passwords.csv: seats.json
	@jq --raw-output '. as $$root | .seats[] | "seat\(.index).\($$root.domain);\(.password)"' seats.json >$@
