---
title: "Understanding dbt Cloud Fundamentals"
description: "Covering all the basic aspects of maintaining dbt infrastructure"
date: 2024-09-09T17:44:58Z
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: ./img/dbt/dbt_office.png
  alt:

tags: [💻 Systems]

---

# 📰 Introduction

The dbt tool has garnered a lot of attention in the data ecosystem as it's managed to simplify the process of building data pipelines in the transform step. 

The key selling point of dbt is its ability to abstract/automate away certain DDL processes such as creating tables, so you can focus more strongly on developing business logic which will provide value to your business.

Developing with dbt will encourage you to break complex SQL procedures into smaller composable segments. This has the advantage of being:
- Easier to read
- Easier to build
- Easier to maintain
- Easier to test

If you are interested in building data with dbt, I highly recommend taking the ***[dbt fundamentals course](https://learn.getdbt.com/courses/dbt-fundamentals)*** in conjunction with reading the documentation which was formative in writing this article.

> You can check out this repository to see how I structure my personal dbt project: ***https://github.com/Filpill/dbt_learn***

You can connect dbt to any database or data warehouse instance, but I will walk through my experience with using the tool and how it integrates with the ***BigQuery data warehouse.***

## 🛠️ Installing dbt Cloud CLI tool

The CLI tool can be a pretty handy way to interface with dbt cloud. You will conveniently be able to run dbt commands through your own customized environment which is neat. And to an extent its more convenient to deal with merge conflicts when you are already embedded in a terminal-like environment.

In order to install this utility you would need to **ensure you do not have dbt core installed on the machine** which would otherwise cause conflicts with running dbt commands.

Installing the CLI tool is a straightforward process. You can download the latest installation from: ***https://github.com/dbt-labs/dbt-cli/releases***

You will need to make a dbt configuration file which exists in the following path: ***~/.dbt/dbt_cloud.yml***

![dbt CLI Config Path](/img/dbt/dbt_cli_config.png#center)

From the dbt website you can create your project and account information which can be copied into the aforementioned file. This will allow you to connect to dbt cloud in order to execute commands in your managed environments:

![dbt CLI Config Download Link](/img/dbt/dbt_cli_config_download.png#center)

Lastly, the ***dbt program*** itself needs to be extracted into the root directory of the git repository storing dbt files. In this setup, dbt commands will only execute from folder its situated in. There is a way of applying this program globally across any directory, but requires some extra system configuration.

![dbt CLI](/img/dbt/dbt_cli.png#center)

## 👥 Creating a Service Account

When running dbt deployments, its not going to be feasible to run scheduled jobs from a personal user account. 

Ideally you want some kind of **service account** that is not bound to any particular user or require any extra authentication steps. 

Service accounts should have their permissions sufficiently restricted to the tasks they are supposed to perform. At a minimum the account should have **BigQuery Editor** and **BigQuery Job User** permissions.

![GCP Service Account Permissons](/img/dbt/gcp_service_account_perms.png#center)

> ***In this educational scenario, I'm using the same service account across the multiple dev/uat/prod projects setups.***

## 🏭 Connecting to Data Warehouse

Provided you have a service account and GCP project created, you can fill out the connections form on dbt cloud to create the interface.

Simply attaching the private JSON key from your service account will auto populate all the fields leaving you only needing to fill the project ID field.

![GCP Connection Detail](/img/dbt/gcp_connection_detail.png#center)

The default project is stored at the connection level, however, when deploying to different environments, you will be able to specify override conditions to target alternative databases/projects in either the environment or job settings.

## 💾 Connecting to Git Repository

Connecting to Git is a straightforward affair, as long as you have repository pre-created, you can simply hook up dbt cloud to it can give it authorisation to modify the repo.

Repositories exist at a per dbt project level as seen here:

![dbt project details](/img/dbt/dbt_project_details.png#center)

If you wish to use segregated git repo's, you would need to instantiate more dbt projects.

The git integration allows you to easily inspect which files are being added/changed/removed. Overall, it should help you make a more conscious effort in grouping git commits appropriately.

Continuously developing dbt models alongside production code is core to leveraging the system to its fullest.

## 🧱 Development File Structure

There should be a button on the side bar to initialise a dbt project. On doing so, dbt will instantiate numerous folders which all serve a unique purpose when developing your data pipeline.

![dbt file structure](/img/dbt/dbt_file_structure.png#center)

It may seem a little overwhelming at first, however, this folder structure helps enforce a more uniform development style in organisation. 

Additionally, it significantly simplifies your SQL into smaller readable chunks which are easier to maintain. Data lineage consequently becomes clearer as you can more easily track data dependencies. 

All data sources are denoted clearly, with all the connections between staging models and dependencies flowing into production models.

![dbt data lineage](/img/dbt/dbt_data_lineage.png#center)

I'll list out a brief summary of the components you will most frequently work with:

#### {{< color background-color="#702963" color="#FFF" >}}&nbsp;Configuration Files{{< /color >}}

Every dbt project will be initialised with a configuration in the root directory called: ***dbt_project.yml**.

This file houses project level configurations that can globally affect models in the entire repository. For example you can change the materialisation of models in the project to *tables* as opposed to views (which are the default output). You can also confine the materialisation config to specific model directories.

![dbt project materilisation](/img/dbt/dbt_project_material.png#center)

Project variables can also be set inside the ***dbt_project.yml*** to be used globally across models:

![dbt project variables](/img/dbt/dbt_project_vars.png#center)

Additionally, as you develop out your dbt project, you can add further yaml files to the **models** directory to set up configurations for source data and for staging data. 

Within these specific configuration files you will be able to add test cases, documentation, and also data freshness checks for targeted models:

Testing:
![dbt generic testing](/img/dbt/dbt_yaml_test.png#center)

Data Freshness Checks:
![dbt data freshness check](/img/dbt/dbt_data_freshness.png#center)


Configuration files are crucial to effectively segmenting, testing and documenting your dbt models.

#### {{< color background-color="#8ec1f5" color="#0A0A0A" >}}&nbsp;Models{{< /color >}}

The models directory is storage for chunks of SQL transformation (SQL dbt models). You can also include sub-folders inside to further organise the work. Examples of sub directories can be:

- **staging:** directory for pulling in data from raw/source tables and proceeding to apply intermediate transformations.
- **mart:** directory for storing finalised transformations ready for analytics; can be further subdivided into more folders relating to specific business units

**How to reference various objects:**
- Data sources: ***{{ source('dataset','table') }}***
- Staging Tables: ***{{ ref('stg_table') }}***
- Variables: ***{{ var('variable_name') }}***

Example of dbt source/ref/var functions:

![dbt data ref funcs](/img/dbt/dbt_reference_func.png#center)

Compiled SQL:

![dbt data ref funcs](/img/dbt/dbt_reference_compiled.png#center)

Notice how we are able to easily replace in the targets very easily. This make deployments to other environments almost trivial to implement.

> ***Raw BigQuery SQL typically has difficulty in having dynamic project/dataset/tables names (unless you are happy to implement a heavy dose of dynamic SQL) -- Dbt on the other hand makes this process trivial to deal with.***


#### {{< color background-color="#f5eb5b" color="#000" >}}&nbsp;Macros{{< /color >}}

If you are writing SQL in a traditional database system, you might see yourself re-writing the same portion across various SQL scripts. **User defined functions** (UDF) typically alleviate some that repetition to reduce code redundancy.

Dbt macros are much akin to the aforementioned UDF, though you can expect more flexibility and extensibility from macros. *But why is that so?* -- ***SQL written in a dbt model is pre-compiled before executing against the data warehouse.*** Dbt macros makes use of the Jinja (a pythonic programming language) to dynamically compile your SQL.

Lets imagine an extreme example of writing a gigantic case statement with hundreds of scenarios. Imagine how tedious it is copy pasting all those conditions by hand. Imagine trying to debug that case statement weeks later. *Borderline garbage experience...*

With the use of Jinja you can put all these conditions into a list and iterate through with a loop to compile your SQL. There are a few of advantages:
- **Looks compact** from a dbt model perspective; typically less lines, and easier to read.
- **Project variables** can be shared with other dbt models.
- **Reduces human error** when building out dbt models.

Here is an example where you can build a list expansion into your SQL compilation.

**Macro definition:**
![dbt macro example](/img/dbt/dbt_expand_list_macro.png#center)

**Reference to macro in model:**
![dbt macro reference](/img/dbt/dbt_macro_reference.png#center)

**Resulting compiled SQL:**
![dbt macro compiled SQL](/img/dbt/dbt_macro_compiled.png#center)

> ***You will benefit from macros in a range of implementations. It really comes down to a degree of creativity in reducing repeatability.***

#### {{< color background-color="#7feb4d" color="#000" >}}&nbsp;Tests{{< /color >}}

**Dbt tests come in two flavours:**
- **Singular:** Bespoke SQL saved in a SQL file within the tests folder to be executed by the test command.
- **Generic:** Pre-built dbt tests which can be applied via the yaml configuration on specified models.
    - **unique:** Ensuring selected column in model is unique.
    - **not_null:** Ensuring selected column in model doesn't contain any nulls.
    - **accepted_values:** Ensures the selected column is only composed of values of a defined list.
    - **relationships:** Verifies referential integrity between 2 tables.


![dbt test](/img/dbt/dbt_test.png#center)

Generic tests should take you fairly far in monitoring pipeline data quality. **Singular tests** should be reserved for **special transformation/logic that needs to be rigorously assessed.**

> The dbt testing feature is really powerful, you are able to able to have full test coverage at every stage of your data pipeline and clearly identify quality issues to be fixed.

##  📝 Documentation

Documentation occurs inside the configuration files to record information about sources, data models, business context, columns, data types and more.

Additionally, within the **models** directory, you are able to create a ***_docs.md*** file which can store multi-line text blocks or tables in markdown. 

![dbt document block](/img/dbt/dbt_doc_block.png#center)

You can use the **{{ doc('') }}** reference to insert those text blocks. This also ideal for reducing clutter in configuration files.

![dbt document block insertion](/img/dbt/dbt_doc_block_insert.png#center)

After writing out your dbt documentation, you can run the following dbt command to compile documents into HTML: ***dbt docs generate***.

![dbt document generation](/img/dbt/dbt_docs_generate.png#center)

You can then proceed to review the compiled documents on the dbt cloud interface on the web.

This is much better than filing information onto a completely separate system where no doubt somebody will forget to update the docs. 

Dbt documentation is a more natural and procedural approach to documenting your data models and overall feels less of chore to do vs other corporate solutions such as **confluence**. Its also easier to clean up after you decide to deprecate certain dbt projects/solutions. *Less rotting documentation...*

> ***Running documentation directly in dbt keeps it alive and significantly less likely to get orphaned in your development cycles.***

## 🌥 Environments

There are a plethora of ways to manage environments in your data warehouse and it's completely up to you to decide how to create environmental segmentation.

Dbt will **always mandate a dedicated development environment** within a project which is where you will be developing your dbt models. Typically, when you run development models, they will land in a user schema/dataset e.g. **dbt_filip_livancic**. This will isolate your outputs and avoid collisions with other developers building in parallel.


![dbt develop creds](/img/dbt/dbt_develop_credentials.png#center)

However, when we start to deploy our datasets into production environments, we should avoid inter-mingling development and production schemas/datasets, and possibly trigger different data volumes or model refresh frequencies.

One way to create that segmentation is to setup environments in different BigQuery Projects, for example we can define the following projects:
- **Develop** - for developing data models
- **UAT** - for data quality testing and validation
- **Production** - for analytical consumption

> ***The term "project" is used here interchangably with "database". The terminology is specific to BigQuery.***

In order to push to separate projects, we must utilise some specific features in dbt to enable it: 

#### {{< color background-color="#006666" color="#FFF" >}}&nbsp;Extended Attributes{{< /color >}}

Inside **Extended Attributes** you can define configuration overrides which must be defined in YAML.

When creating a dbt production environment for instance, we are able to specify a target name (which refers to the dbt environments) and the project name which relates to the target environment:

![dbt extended attributes](/img/dbt/dbt_extended_attr_target.png#center)

Effectively what we are doing is creating an override to the destination project for production. If we did not specify these overrides, the output would land in the default project you defined in your data warehouse connector.

#### {{< color background-color="#a98600" color="#000" >}}&nbsp;Environment Variables{{< /color >}}

Additionally, we can to leverage environmental variables to point our objects to the correct deployment environment when we are either developing or productionising:

![dbt environment variable](/img/dbt/dbt_saved_env_var.png#center)

The usage is particularly useful for source objects, where we can use environment variables to point them to dev or prod projects.

![dbt source environment](/img/dbt/dbt_src_env_var.png#center)

## 🛣 Deployments and Jobs

When it comes to deploying to different environments, we can leverage these different connections to push to different target environments, which in our case would be different GCP project_id's.

Examples of jobs you can design:
- An **ad-hoc** job which manually runs a deployment, can be suitable for landing data in a test environment.
- A **daily-scheduled** job which would deploy to a production environment on a daily basis.

![dbt jobs](/img/dbt/dbt_jobs.png#center)

The dbt scheduler can be a useful option for orchestrating jobs for your data warehouse; it feels fairly natural to monitor and fix pipelines within the same ecosystem.

## 💬 Closing Commentary

This was a fairly rudimentary outline in utilising dbt, however, it was primarily written with the intent of recounting my experience of using dbt.

Thought it more-or-less encompasses all the aspects you would interact with on a daily basis. You can read the further into the official docs for orchestrating a legitimate dbt project.

But after my brief experience with the tool, I can see why people convert over to the *church of dbt*.
