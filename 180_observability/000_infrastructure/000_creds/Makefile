EVENT_NAME := 20260416
SEAT_COUNT := 21
DOMAIN     := inmylab.de

seats.json:
	@EVENT_NAME=$(EVENT_NAME) SEAT_COUNT=$(SEAT_COUNT) DOMAIN=$(DOMAIN) bash generate.sh

passwords.csv: seats.json
	@jq --raw-output '. as $$root | .seats[] | "seat\(.index).\($$root.domain);\(.password)"' seats.json >$@
