Berndwl/docker-backup-mongo-to-s3
======================

Docker container that periodically backups mongodb files to S3 instance using [s3cmd put](http://s3tools.org/s3cmd-sync) and cron.

### Usage

    docker run -d [OPTIONS] wolved/docker-mongo-backup-to-s3

### Parameters:

* `-e ACCESS_KEY=<AWS_KEY>`: Your AWS key.
* `-e SECRET_KEY=<AWS_SECRET>`: Your AWS secret.
* `-e HOST_BASE=<AWS_HOST_BASE>`: Your S3 host base.
* `-e HOST_BUCKET=<AWS_HOST_BUCKET>`: Your S3 host bucket.
* `-e S3_PATH=s3://<BUCKET_NAME>/<PATH>/`: S3 Bucket name and path. Should end with trailing slash.
* `-e MONGODB_PARAMS=<MONGODB_PARAMS>`: Mongodb params, for example to authenticate to database or chose specific collection(s).
* `-v /path/to/backup:/data:ro`: mount target local folder to container's data folder. Content of this folder will be synced with S3 bucket.

### Optional parameters:

* `-e PARAMS="--dry-run"`: parameters to pass to the sync command ([full list here](http://s3tools.org/usage)).
* `-e DATA_PATH=/data/`: container's data folder. Default is `/data/`. Should end with trailing slash.
* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).

### Examples:

Run mongo upload to S3 everyday at 12:00pm:

    docker run -d \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        -e 'CRON_SCHEDULE=0 12 * * *' \
        -v /home/user/data:/data:ro \
        wolved/docker-mongo-backup-to-s3
