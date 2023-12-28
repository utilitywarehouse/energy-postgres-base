BITNAMI_POSTGRES_RELEASE=13.2.24

.PHONY: gen-postgresql
gen-postgresql:
	docker run -ti --rm \
			--volume $${PWD}:/opt/manifests \
			--env BITNAMI_POSTGRES_RELEASE=${BITNAMI_POSTGRESQL_RELEASE} \
			--workdir=/opt/manifests \
			--entrypoint=/bin/sh \
			alpine/helm ./gen-yaml/gen.sh
