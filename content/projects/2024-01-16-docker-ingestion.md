---
title: "Dockerised Postgres Database and Ingestion"
description: "Basics of setting up a database and ingestion system in a series of docker containers"
date: 2024-01-16
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: ./img/docker/docker_pipeline_cover.png
  alt: docker pipeline cover image

tags: [💻 Systems]
---

## Summary
This article goes through the process of incorporating Docker as a tool for creating a data ingestion system into a Postgres database. We will containerise both the database and the Python ingestion scripts.

The Github project this article is based on can be found here: [github_repo: nba_stats](https://github.com/Filpill/nba_stats/tree/main)

## Required Containers
We will be building 4 containers to manage the data ingestion:
- Postgres - Hosting a database
- Psql - Running Postgres CLI Tool (Another Postgres Instance)
- PgAdmin - Managing Postgres
- Python - Ingesting Data into Postgres DB

### The container set-up:

{{<mermaid>}}

graph LR;
    subgraph Stage 1: localhost - Prepare Data
    0([API - <br><strong>data_extraction.py</strong>])
    1([Create <br><strong>data_ingestion.py</strong>])
    cli0([Create <br><strong>ETL SQL Files</strong>])
    2([Postgres/PgAdmin <br><strong>docker-compose.yaml</strong>])
    3[Python <br><strong>Dockerfile</strong>]
    cli0--Copy .sql Files--> cli1([psql<br><strong>Dockerfile</strong>])
    0--Copy Data-->3
    1--Copy Script-->3
    end

    subgraph Stage 2: Docker Containers - Ingestion Pipeline
    subgraph Container Network 
    2-->D0([compose <br><strong>Postgres DB</strong>])
    2-->D1([compose <br><strong>PgAdmin</strong>])
    3-->D2([build <br><strong>Python</strong>])
    cli1-->cli2([build <br><strong>psql</strong>])
    end

    subgraph ETL/ELT 
    D0-->DB[(Database)]
    D1--Manage DB-->DB
    D2--Ingest<br>Data-->DB
    cli2--ETL <br>via shell -->DB
    end
    end                                        

    subgraph Stage 3: Visualisation
    DB--Live<br>Query-->viz[Connect DB <br>to Visualisation Tool]
    end
    
{{</mermaid>}}

#### Stage 1 - Prepare Raw Data
1. Retrieving data from an open-source API providing NBA data: [balldontlie.io](https://balldontlie.io/home). 
2. Python scripts to request JSON data from all endpoints.
3. Merge JSON data into a consolidated file for each endpoint.

#### Stage 2 - Create Dockerised Data Ingestion Pipeline
4. Create Dockerised instance of Postgres database.
5. Create Dockerised instance of PgAdmin to connect and manage database.
6. Create tables into Postgres DB using Dockerised Python ingestion script.
7. Use SQL to transform data and create tables for analytical capability.
8. Automate the ETL procedure by running SQL scripts with psql.

#### Stage 3 - Analyse and Visualise Data
9. Connect dashboarding tool to database and showcase data visualisations.

### Why Docker?

***What's the purpose of containerising Python and Postgres?***

One of Dockers greatest strengths is the ability to standardise a software environment in order to run a collection of applications:
- It's much more efficient than creating an entire Virtual Machine in order to replicate a "standardised environment".
- Docker containers share its resources natively with the host, which means your application only uses the compute it needs. 
- The container build files can be deployed easily to any computer/cloud/server and it will run identically on all instances.

A virtual machine has to reserve a portion of system resources such as the Memory and Drive space. Virtual machines are not scalable resources at runtime. This limits how many instance you can spin up on a given computer/server. 

To sum up: containerisation provides easier code deployment/distribution, and can be scaled more easily in conjunction with cloud technology.

### Data Ingestion Pipeline

#### Building Postgres and PgAdmin Containers Simultaneously

Docker has a utility called **docker-compose** which provides the capability of creating multiple services simultaneously from a **.yaml** file. All images are created simultaneously.

A natural benefit of this utility is that docker automatically sets up a default networking configuration for containers to communicate with each other in the same config.

I've decided to run Postgres and PgAdmin in the same configuration file since it would be natural to be natural to pair the database with DBMS.

```yaml
services:
    pgdatabase:
        image: postgres:13
        environment:
          - POSTGRES_USER=root
          - POSTGRES_PASSWORD=root
          - POSTGRES_DB=nba
        volumes:
          - "./nba_postgres_data:/var/lib/postgresql/data:rw"
        ports:
          - "5432:5432"
    pgadmin:
        image: dpage/pgadmin4
        environment:
          - PGADMIN_DEFAULT_EMAIL=admin@admin.com
          - PGADMIN_DEFAULT_PASSWORD=root
        ports:
          - "8080:80"
```

This file must be called **docker-compose.yaml** in order to be able to run the command: ***docker compose up***.

This will instantiate those two services under the same network so they are able to communicate with each other.

#### Building Container for Data Ingestion Script

For the purposes of my system, I have decided to keep my ingestion script separate from my other 2 containers. I don't want to invoke the ingestion process every time I run the database. This process I've kept manual for now.

We can create an independent Docker image and connect via the default network generated by the "docker-compose" tool.

To create a singular docker image, you need a **Dockerfile**. For this project, it looks like this:

```Docker
FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY data_ingestion.py data_ingestion.py
COPY data/combined data

ENTRYPOINT [ "python", "data_ingestion.py" ]
```

In this Dockerfile I am specifying:
- The software versions and packages.
- The working directory.
- Local files/scripts to be copied.
- Entering program directly through Python.

To build the image from the Dockerfile, you will need to run the following Docker command:

***Note: If you are running docker from Windows, you must prefix docker commands with "winpty"***

```bash
docker build -t nba_ingest:v001 .
```
The build command has generated an image called **nba_ingest:v001**.

However to run the image in a container, we can use the **docker run** command as follows.

The command is structured in a manner to pass to docker arguments to the docker tool and the python arguments to the image containing the python script.

```bash
docker run -it \
    --name=pyingest \
    --network=docker_sql_default \
    nba_ingest:v001 \
	--user=root \
	--password=root \
	--host=pgdatabase \
	--port=5432 \
	--db=nba \
```

As per the command, we have named this container **pyingest**. Which means we cannot run the same run command again.

Therefore, if the container stops and you want to run the program again; you can simply use the command:

```bash
docker start -i pyingest
```
#### Container Summary

After this entire process, you should 3 containers that look like this:

![docker_containers](/img/docker/docker_containers.jpg#center)

#### Networking Explanation

In this specific scenario we are working in, we do not need to manually create a network as mentioned earlier.

This is automatically defined by the docker-compose process we ran earlier. We can simply borrow the default network name in order to connect this container to the database.

The default name of the network from docker-compose is the working directory of the .yaml file suffixed with **"_default"**.

You can verify this by running the command:

```bash
docker network ls
```

Since our working directory is **docker_sql**, the network created earlier is called **"docker_sql_default"**. We have simply applied this to the network argument in our docker run command to allow the connection between those containers.

#### PgAdmin - Data Transformation

From this point forward, you will have a data ingestion pipeline running, all you need to do is connect to the DBMS to enact transformations on the data we have ingested.

We can access PgAdmin in our browser via the port number we have designated: [localhost:8080](localhost:8080)

### Automated Docker Container/Image Rebuilding
 You are in the process of developing or changing containers configurations, you will likely encounter the issue of having to delete the containers/images and re-build them. If you are doing this for isolated containers, it can become very annoying and repetitive. 

 To avoid running the docker rm and build commands constantly, consider building a script to automate that process to speed up your config changes:

```bash
#!/bin/bash
container="psql_contain"
image="psql:v001"


# Re-Build Container with New Configuration
function update_container {
    winpty docker rm $container
    winpty docker rmi $image

    winpty docker build -t $image .
    winpty docker run -it \
	--name=$container \
	--network=docker_sql_default \
	$image 
}

# Run Dockerised Python Ingestion Script
function run_script {
    winpty docker start -i $container
}

declare -A container_options=(
    [1]="1 - Update Container/Image with New Configuration" 
    [2]="2 - Run psql" 
)
keys_sorted=($(echo ${!container_options[@]} | tr ' ' '\n' | sort -n))

while true; do
    echo "=============================================="
    echo "Please Select An Action (Enter Integer Value):"
    echo "=============================================="
    for key in "${keys_sorted[@]}"; do
        echo "  ${container_options[$key]}"
    done
    read num
    case $num in
        1) update_container ;;
        2) run_script ;;
        *) 
            clear
            echo "-------------------------------------------------"
            echo "---  Invalid Selection - Enter Value on List  ---"
            echo "-------------------------------------------------
            "
            continue ;;
    esac
    break
done
```

This script will give you two options:
- **Selecting Option 1** - If you need to re-image the container because you updated your scripts or have new data to be copied into the container. 
- **Selecting Option 2** - Will simply run the existing container in its current state.

I've made multiple instances of this scripts for each individual image/container pair. But it's a little redundant given the duplicity.  It would be wiser to pass in parameters for an image name and container name via some config or secondary script. I'll rework this concept/soltion in the future.

But my main point here is that we want to avoid manually typing out Docker commands. Once we internalise what each command does, its much better to automate that process.

## Automating the ETL with psql

Ideally we don't want to manually run an ETL process every day via the graphical interface. We want to free up our time to engage in other work in parallel. Therefore, I would strongly suggest the incorporation of scripting out the transformation process.

Thankfully, Postgres comes pre-packaged with psql which is a command-line tool to interface with the database. Using this tool we are able to execute a series of SQL scripts to transform the data to our requirements in the destination tables.

Even though Postgres, comes with psql, I decided to load it into a separate container strictly for the purpose of ETL which is arguably a more bloated way of dealing with the situation, (but we'll run with it for the sake of having a functional system).

For purposes of running it independently from the "docker-composition", this program will be in it's own container with an independent Dockerfile:

```Dockerfile
FROM postgres:13

WORKDIR /app

COPY tf tf
COPY etl.sh etl.sh

ENTRYPOINT [ "bash" ]

RUN chmod +x etl.sh

CMD [ "./etl.sh" ]
```

We will be entering this container via bash and automatically executing our **etl.sh** script. The script points to all the SQL files we have saved in the folder named **tf**.

Under the hood of the etl.sh script is simply a one-liner psql command which after logging into the relevant database, runs all the SQL files I have specified explicitly:

```bash
#!/bin/bash
psql postgresql://root:root@pgdatabase:5432/nba -f tf/create_tf_season_averages.sql -f create_tf_unioned_games.sql
```

You can have as many or as little SQL scripts as you need.

I haven't set it up yet but assuming you have a server arrangement, you can schedule to run this Docker container using a **crontab** (daily, weekly, monthly etc). And you can easily run the psql ETL container without your intervention.

## Conclusion

Hopefully this article illustrates the power and utility of Docker as a tool.You should be able to build a rudimentary database system which can easily be deployed on a server or cloud provider. 

Although further care should be considered with the passwords and how to protect them as they are visibly bundled in all the scripts. So, consider how to incorporate password encryption and improve security for this set up.

I will follow up in a later article when I get a chance to process and analyse all the NBA data from the API. I will likely try to visualise the NBA dataset using streamlit hosted on a Raspberry Pi.
