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

# 📰 Summary

The dbt tool has garnered a lot of attention in the data ecosystem as it's managed to simplify the process of building data pipelines in the transform step. 

The key selling point of dbt is its ability to abstract/automate away certain DDL processes such as creating tables, so you can focus more strongly on developing business logic which will provide value to your business.

Developing with dbt will encourage you to break complex SQL procedures into smaller composable segments. This has the advantage of being:
- Easier to read
- Easier to build
- Easier to maintain
- Easier to test

I recommend taking this ***[dbt fundamentals course](https://learn.getdbt.com/courses/dbt-fundamentals)*** in conjunction with the dbt documentation which is the foundation for the article.

You can connect dbt to any database or data warehouse instance, but I will walk through my experience with using the tool and how it integrates with the BigQuery data warehouse.

## 🛠️ Installing dbt Cloud CLI tool

The CLI tool can be a pretty handy way to interface with dbt cloud. You will conveniently be able to run dbt commands through your own customized environment which is neat. And to an extent its more convenient to deal with merge conflicts when you are already embedded in a terminal-like environment.

In order to install this utility you would need to **ensure you do not have dbt core installed on the machine** which would otherwise cause conflicts with running dbt commands.

Installing the CLI tool is a straightforward process. You can download the latest installation from: https://github.com/dbt-labs/dbt-cli/releases

You will need to make a dbt configuration file which exists in the following path: ***~/.dbt/dbt_cloud.yml***

From the dbt website you can create your project and account information which can be copied into the aforementioned file. This will allow you to connect to dbt cloud in order to execute commands in your managed environments.

Lastly, the ***dbt program*** itself needs to be extracted into the root directory of the git repository storing dbt files. In this setup, dbt commands will only execute from folder its situated in. There is a way of applying this program globally across any directory, but requires some extra system configuration.

## 👥 Creating a Service Account

When running dbt deployments, you don't want to be running scheduled jobs from a personal user account. User accounts are inherently ephemeral on a long enough scale which creates reliability issues for pipelines. 

More so, you are inviting a significant security vulnerability into your system if you are sharing your personal credentials across people in an organisation.

Ideally you want some kind of **service account** that is not bound to any particular user or require any extra authentication steps. 

Service accounts should have their permissions sufficiently restricted to the jobs its supposed to perform. In our case it would be fiddling with BigQuery administration and deployments with dbt specifically.

## 🏭 Connecting to Data Warehouse

Provided you have a service account and GCP project created, you can fill out the connections form on dbt cloud to create the interface.

Simply attaching the private JSON key from your service account will auto populate all the fields leaving you only needing to fill the project ID field.

It's worth understanding that each connection can only execute against the project ID you are connecting to. Therefore the default environment segmentation exists in the dataset level. It's a little annoying to deal with given that this would intermingle development and production datasets.

## 💾 Connecting to Git Repository

Connecting to Git is a straightforward affair, as long as you have repository pre-created, you can simply hook up dbt cloud to it can give it authorisation to modify the repo.

The git integration allows you to visually inspect which files are being added/changed/removed. Overall, it should help you make a more conscious effort in grouping git commits appropriately.

Continuously developing dbt models alongside production code is core to leveraging to the system to its fullest.

## 🧱 Development File Structure

Initialising a dbt project will instantiate numerous folders which all serve a unique purpose when developing data pipelines.

It can be a little overwhelming at first, however, this folder structure helps enforce a more uniform style of development in a team of developers. Additionally, it significantly simplifies your SQL into smaller readable chunks which are easier to maintain. Consequently, data lineage becomes almost crystal clear as you can more easily track data dependencies.

#### {{< color background-color="#702963" color="#FFF" >}}&nbsp;Configuration Files{{< /color >}}

Every dbt project will be initialised with a configuration in the root directory called: ***dbt_project.yml**.

This file will house project level configurations that can globally affect models in the entire repository. As a simple example you can change materialisation of models in the project to *tables* as opposed to views (which are the default output). You can also confine the materialisation config to specific directories.

Additionally, as you develop out your dbt project, you can add further yaml files to the **models** directory to set up configurations for source data and for staging data. Within these specific files you will be able to add test cases, documentation, and also data freshness checks.

These configuration files are crucial to effectively segmenting, testing and documenting your dbt models.

#### {{< color background-color="#8ec1f5" color="#0A0A0A" >}}&nbsp;Models{{< /color >}}

The models folder is where you house developments for your various SQL transformation. You can also include sub-folders inside to further organise the work. Examples of sub directories can be:

- **staging:** directory for pulling in data from raw/source tables and proceeding to apply intermediate transformations.
- **mart:** directory for storing finalised transformations ready for analytics; can be further subdivided into more folders relating to specific business units


#### {{< color background-color="#f5eb5b" color="#000" >}}&nbsp;Macros{{< /color >}}

If you are writing SQL in a traditional database system, you might see yourself re-writing the same portion across various SQL scripts. **User defined functions** (UDF) typically alleviate some that repetition to reduce code redundancy.

Dbt macros are much akin to the aforementioned UDF, though you can expect more flexibility and extensibility from macros. ***But why is that so?*** -- SQL written in a dbt model is pre-compiled before executing against the data warehouse. Dbt macros makes use of the Jinja (a pythonic programming language) to dynamically compile your SQL.

Lets imagine an extreme example of writing a gigantic case statement with hundreds of scenarios. Imagine how tedious it is copy pasting all those conditions by hand. Imagine trying to debug that case statement weeks later. Terrible...

With the use of Jinja you can put all these conditions into a list and iterate through with a loop to compile your SQL. There are a few of advantages:
- **Looks compact** from a dbt model perspective; typically less lines, easier to read.
- **Project variables** can be shared with other dbt models.
- **Reduces human error** when building out dbt models.

Macros will still benefit you across the board in smaller implementations. It really comes down to a degree of creativity in reducing repeatability.

#### {{< color background-color="#7feb4d" color="#000" >}}&nbsp;Tests{{< /color >}}

Dbt tests come in two flavours:
- **Singular:** Bespoke SQL saved in a SQL file within the tests folder to be executed by the test command.
- **Generic:** Pre-built dbt tests which can be applied via the yaml configuration on specified models.
    - **unique:** Ensuring selected column in model is unique.
    - **not_null:** Ensuring selected column in model doesn't contain any nulls.
    - **accepted_values:** Ensures the selected column is only composed of values of a defined list.
    - **relationships:** Verifies referential integrity between 2 tables.

I anticipate the generic tests will take you fairly far in monitoring pipeline data quality. The *singular* tests should only be applied where you have some special transformation/logic that needs to be regularly assessed.

The dbt testing feature is really powerful, you are able to able to have full test coverage at every stage of your data pipeline and clearly identify quality issues to be fixed.

##  📝 Documentation

Documentation occurs inside the configuration files to record information about sources, data models, business context, columns, data types and more.

Additionally, within the **models** directory, you are able to create a ***_docs.md*** file which can store multi-line text blocks or tables in markdown. You can use the **{{ doc('') }}** reference to insert those text blocks. This is ideal for improving the readability of a configuration file.

After writing out your dbt documentation, you can run the following dbt command to compile everything together: ***dbt generate docs***.

You can then proceed to review the compiled documents on the dbt cloud interface on the web.

This is much better than filing information onto a completely separate system where no doubt somebody will forget to update the docs. 

Dbt documentation is a more natural and procedural approach to documenting your data models and overall feels like less of chore to do vs other corporate solutions such as **confluence**. And its easier to clean up after you decide to deprecate certain dbt projects/solutions.

***Running documentation directly in dbt keeps it alive and significantly less likely to get orphaned in your development cycles.***

## 🌥 Environments

There are a plethora of ways to manage environments in your data warehouse and it's completely up to you to decide how to create environmental segmentation.

Dbt will **always mandate a dedicated development environment** within a project which is where you will be developing your dbt models. Typically, when you run development models, they will land in a user schema/dataset. This will isolate your outputs and avoid collisions with other developers building in parallel.

However, when we start to deploy our datasets into production environments, we want to avoid inter-mingling development and production datasets where possible...

The way I have personally set environments up is through the use of multiple separate data warehouse connections. For example I can specify a:
- **Develop** project connection - for developing data models
- **UAT** project connection - for data quality testing
- **Production** project connection - for analytical consumption

In each environment, we can house different levels of data volumes or different model refresh frequencies.

## 🛣 Deployments and Jobs

When it comes to deploying to different environments, we can leverage these different connections to push to different target environments, which in our case would be different GCP project_id's.

You can have at least two categories of jobs:
- An **ad-hoc** job which manually runs a deployement, can be suitable for landing data in a test environment.
- A **daily-scheduled** job which would deploy to a production environment on a daily basis.

This can be a useful option for orchestrating jobs in your data warehouse as you can interpret error logs and fix pipelines much more easily as developer tools are more accessible. Additionally, you have built data pipeline/job health checks so you can monitor the reliability of your pipelines.
