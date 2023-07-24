up:
	@docker compose --file docker-compose.yaml up -d

down:
	@docker compose --file docker-compose.yaml up -d

up--%:
	@docker-compose --file docker-compose.yaml up -d $*

stop--%:
	@docker-compose --file docker-compose.yaml stop $*

rm--%:
	@docker-compose --file docker-compose.yaml rm $*

down--%: compose-stop--% compose-rm--%

up-backend: up--redis up--postgres

up-frontend: up-gitaly up--gitlab

ps:
	@docker-compose --file docker-compose.yaml ps

logs--%:
	@docker-compose --file docker-compose.yaml logs $*

logsf--%:
	@docker-compose --file docker-compose.yaml logs -f $*

exec--%:
	@docker-compose --file docker-compose.yaml exec $* sh