---
title: "Understanding dbt Cloud Fundamentals"
description: "Covering all the basic aspects of maintaining dbt infrastructure"
date: 2024-09-09T17:44:58Z
hideSummary: false
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: true

cover:
  image: ./img/dbt/dbt_office.png
  alt:

tags: [💻 Systems]

---

{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0([Process Start])-->A[Step 1]
    end
{{</mermaid>}}

# Summary

dbt is a data transformation tool which is designed to help increase developer efficiency. 

The dbt tool has garnered a lot of attention in the data ecosystem as it helps embed better practises whilst simplifying the process of building data pipelines. 

The key selling point of dbt is its ability to abstract/automate away certain DDL processes such as creating tables, so you can focus more strongly on developing business logic which will provide value to your business.

Developing with dbt will encourage you to break complex SQL procedures into smaller composable segments. This has the advantage of being:
- Easier to build
- Easier to read
- Easier to test
- Easier to restart

You can connect dbt to any database or data warehouse instance, but I will walk through my experience with using the tool and how it integrates with the BigQuery data warehouse.

## Installing dbt Cloud CLI tool

The CLI tool can be a pretty handy way to interface with dbt cloud. You will conveniently be able to run dbt commands through your own customized environment which is neat. And to an extent its more convenient to manage the emergence of merge conflicts when you are already embedded in a terminal-like environment.

In order to install this utility you would need to **ensure you do not have dbt core installed on the machine** which would otherwise cause conflicts with running dbt commands.

Installing the CLI tool is a straightforward process. You can download the latest installation from: https://github.com/dbt-labs/dbt-cli/releases

You will need to have a dbt configuration file which sits inside: ***~/.dbt/dbt_cloud.yml***

From the dbt website you can create your project and account information which can be copied into the aforementioned file. This will allow you to connect to dbt cloud in order to execute commands in your managed environments.

Lastly, the "dbt program" itself needs to be extracted into the root directory of the git repository storing dbt files. In this setup, dbt commands will only execute from folder its situated in. There is a way of applying this program globally across any directory, but requires some extra system configuration.

## Preparing BigQuery Project And Service Account

When running dbt deployments, you don't want to be running scheduled jobs from a personal user account. User accounts are inherently ephemeral on a long enough scale which creates reliability issues for pipelines. 

More so, you are inviting a significant security vulnerability into your system if you are sharing your personal credentials across people in an organisation.

Ideally you want some kind of "service account" that is not bound to any particular user or require any extra authentication steps. 

Service accounts should have their permissions sufficiently restricted to the jobs its supposed to perform. In our case it would be fiddling with BigQuery administration and deployments with dbt specifically.

## Connecting to Data Warehouse

## Connecting to Git Repository

## Development File Structure

### Configuration Files

### models

### macros

### tests

## Deployment Environments and Jobs
