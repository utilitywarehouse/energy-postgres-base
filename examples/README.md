# energy-postgres-base Examples

## With Backup
### Backup Bucket

First you need to create an S3 backup bucket to store the backups in. This is done in [terraform](https://github.com/utilitywarehouse/terraform/) using a terraform [module](https://github.com/utilitywarehouse/system-terraform-modules/tree/main/aws_bucket_access). You will need to add the following blocks

``` hcl
# Your S3 bucket
module "energy-platform-crm-graphql-backup" {
  source = "github.com/utilitywarehouse/system-terraform-modules//aws_bucket?ref=10637497f17452115d1ab42f25a007b1fbed2a80"
  name   = "uw-dev-energy-crm-postgres-backup"
}

# Your S3 bucket access
module "energy-platform-crm-graphql-access" {
  source       = "github.com/utilitywarehouse/system-terraform-modules//aws_bucket_access?ref=10637497f17452115d1ab42f25a007b1fbed2a80"
  bucket_id    = module.energy-platform-crm-graphql-backup.bucket.id
  write_access = true
}

# To output the name of your bucket
output "energy-platform-crm-graphql-bucket-name" {
  value = module.energy-platform-crm-graphql-backup.bucket
}

# To output the name of your role
output "energy-platform-crm-graphql-role-name" {
  value = module.energy-platform-crm-graphql-access.role
}
```

Note down the name of your role and bucket since they will be used later.

### Vault Access

Now we have an S3 bucket we need to allow our kubernetes pods access to this bucket. This is done using [vault](https://www.vaultproject.io/). This means adding a service account to your kubernetes manifests

``` yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  # you will need this name later on
  name: crm-postgres-backup
  annotations:
  # you need your aws role here.
    vault.uw.systems/aws-role: "arn:aws:iam::950135041896:role/energy-crm-postgres-backup-bucket-rw"
```

Again note your service account name.

### Postgres with Backup

With the service account in hand we can create our postgres instance. First copy the example overlays/secrets from [with-backup](./with-backup) to your kubernetes manifests repo. There you will need to update the values for you specific use case.

### Restoration

Apply the restore manifest under examples or copy the backups manually from the S3 bucket you created for the backups.


## Just Postgres

Copy the files from [postgres](./postgres) to your kubernetes manifests repo and update the values appropriately for your use case.

## Migration

If you wish to migrate an existing database to one of the available options
here, you should first take a `pg_dump` of the database in archive mode
(i.e. NOT the default SQL text dump) and then `pg_restore`. You should
port-forward to the corresponding container and ensure you have enough
disk space for the dump (the compressed archive format helps with this).

```
  # <port-forward to the original running postgres>

  pg_dump -Fd "$ORIGINAL_PG_CONNECTION_STRING" -j 5 -f $ARCHIVE_DIRECTORY
  # connection strings are available in strongbox secrets
  # should mkdir $ARCHIVE_DIRECTORY if it doesn't exist
  # adjust `-j` as preferred
  
  # <rm old port-forward and add a new port-forward to the new postgres>
  
  pg_restore -d $NEW_PG_CONNECTION_STRING -C $ARCHIVE_DIRECTORY
  # -C is to create database and might not be needed
```
