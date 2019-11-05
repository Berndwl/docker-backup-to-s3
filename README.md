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
        
Or docker-compose:


    networks:
      your_network:
        name: your_network
        driver: bridge
        ipam:
          config:
          - subnet: 172.16.0.0/24

    services:
      mongo:
        image: mongo
        container_name: 'mongo'
        ports:
          - '27017:27017'
        restart: always
        networks: 
          your_network:
            ipv4_address: 172.16.0.2
        command: mongod --bind_ip 127.0.0.1,172.16.0.2
        environment:
          MONGO_INITDB_ROOT_USERNAME: -
          MONGO_INITDB_ROOT_PASSWORD: -

      mgob:
        image: wolved/docker-mongo-backup-to-s3
        container_name: 'mgob'
        networks: 
          - your_network
        environment:
          - ACCESS_KEY=access_key
          - SECRET_KEY=secret_key
          - S3_PATH=s3://your-path/
          - HOST_BASE=s3.example.com
          - HOST_BUCKET="%(bucket)s.s3.example.com"
          - MONGODB_PARAMS="-u user -p pass --authenticationDatabase admin --db your_db --host 172.16.0.2"
          - 'CRON_SCHEDULE=0 12 * * *'
        depends_on:
          - mongo  
