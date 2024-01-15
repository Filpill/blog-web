---
title: "Containerised Postgres Database"
description: "Basics of Setting up Database in Docker Container"
date: 2024-01-15
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: true

cover:
  image: 
  alt: 

categories: [Computing]
---

## Summary
This article goes through the process of incorporating Docker as a tool for creating a data ingestion system into a Postgres database. We will containerise both the database and the Python ingestion scripts.

### The overall plan:

1. Retrieving data from an open-source API providing NBA data: [balldontlie.io](balldontlie.io/home.html/introduction). 
2. Python scripts to request API data and retrieve all the available JSON's at each endpoint.
3.  Merge the JSON files into a consolidated file for each endpoint.
4. Create Dockerised instance of Postgres and create tables from the raw data.
5. Create Dockerised instance of PgAdmin to connect and manage database.
6. Use SQL to create analytical tables to serve for analytical capability.
7. Host instance of streamlit, connect to database and show visualisations


{{<mermaid>}}
graph TD;
    subgraph Local Python Script
    0([API - Request Data])-->1[Dump Data in Postgres]
    end

    subgraph Docker Container
    1-->2[Raw Data in Postgres <br> w/ Python]
    2-->3[Transform Data via PgAdmin]
    end

    subgraph Raspberry Pi
    3-->4[Host Visualisations on Streamlit]
    end
{{</mermaid>}}

### Why Docker?

***What's the purpose of containerise Python and Postgres?***

One of Dockers greatest strengths is the ability to standardise a software environment in order to run a collection of applications:
- It's much more efficient than creating an entire Virtual Machine in order to replicate a "standardised environment".
- Docker containers share its resources natively with the host, which means your application only uses the compute it needs. 
- The container build files can be deployed easily to any computer/cloud/server and it will run identically on all instances.

A virtual machine has to reserve a large portion of arbitrarily decided system resources such as the Memory and Drive space. These are not scalable resources. This limits how many instance you can spin up on a given computer/server. You can stack a more of containers than VM's on single computer.

Therefore, it's more powerful and efficient to manage a collection of containers; additionally the deployment of code is much easier.

### Data Ingestion System

#### Dockerfile

The main thing you need to create a Docker image is to create a Dockerfile. For this project, it looks something like this:

```Docker
FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY data_ingestion.py data_ingestion.py
COPY data/combined data

ENTRYPOINT [ "python", "data_ingestion.py" ]
```

- You are specifying the software and packages that need to go in this container.
- You are creating the working directory for the container.
- Copying your local files into the container so they can be accessed.
- Invoking the python script and entering program directly


