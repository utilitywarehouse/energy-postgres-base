# energy-postgres-base

> [!WARNING]
> This is still a wip so it not ready for general use.
> - TODO need to fix an issue upstream where the backup directory is not set. [link](https://github.com/eeshugerman/postgres-backup-s3/pull/43)

## Usage
These manifests should be used as a Kustomize base with patches applied to suit your particular use case and requirements. An example of a possible setup is provided in the [examples](./examples) folder. There is a Kustomize base available with a cronjob backup that saves a dump of the database tables and data to an S3 bucket. This can then be restored using a one-time pod. Further setup instructions can be found in the examples [Readme](./examples/README.md).

## Source
The postgres manifest is built on the base of [Bitnami Postgresql Helm Chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)

The backup cronjob is provided by using an [image](https://github.com/eeshugerman/postgres-backup-s3) for backing up to an S3 bucket.

