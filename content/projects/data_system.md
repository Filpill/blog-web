---
title: "Building Data Pipelines With Python: Systems Perspective"
date: 2022-07-23T21:12:42+01:00
draft: true
ShowToC: true

cover:
  image: /img/auto/python_all_auto.png
  alt: Python Automating Everything

tags: [python,sql,powerpoint,outlook,excel,automation,programming]
categories: [data,programming]

---

# Summary

There are endless oppertunities to streamline processes and automate our data production tasks.

This article serves as an example for the wide ranging applications I've been using Python to automate both simple and complex tasks with high efficiency.

# Data Modelling

These are some of the goals we are trying to achieve:

- To build complete end-to-end data solutions from the data source to user.
- We want to minimise manual task interventions during the data processing.
- To build tools which are adaptable to the needs of the business.

This is a high level view of a data analytics pipeline I've built in the past:
{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0A[Data Analyst Initiates Process]-->A
    0A-->B
    end

    subgraph Extract, Transform, and Analyse Data
    A[Shell Scripts]-- exec. via <br>cli tools -->C((Core Driver:<br> Python Scripts))
    B[Task Scheduler]-- auto exec. -->C((Core Driver:<br> Python Scripts))

    D[(SQL Server)]-- data retrieval -->C-- pyodbc -->D
    C--> E(Matplotlib charts)
    C--> F(Pandas tables)

    E-- saved as .png --> G(Saved In Network Drive)
    F-- saved as .csv -->G


    subgraph Create Data Product
    G-- xlsxwriter -->H(Excel<br>Dashboards)
    G-- python-pptx -->I(Powerpoint<br>Presentations)
    end
    end

    subgraph Process Termination
    H-->J(Emails sent via SMTP)
    I-->J

    J-- smtplib -->K[End User Recieves Data Product]
    end
{{< /mermaid >}}

***Note**: Python scripts are chained together to connect the processes together and handle various tasks along the pipeline*

This is the result of incremental upgrades made gradually over time to optimise my workflow. I've saved much time inter-weaving these python libraries together.

As long as the tools are well built, you can bridge them across to new processes easily and maintain them with minimal effort. Not to mention you will be saving hundreds (and maybe thousands of) hours as you execute these processes.

The idea is not to replicate this system one-to-one, but to demonstate the possibilities for connecting automation tools togther.

And perhaps we can learn to make more elaborate systems...



## PyODBC - A SQL Interface For Python

![SQL](/img/logo/sql.png#center)

The most important setup of the automation process is the ingestion of data into the Python environment.

Fortunately for myself, our organisation hosts several Microsoft SQL Servers which form part of our data warehouse.

PyODBC is a python module which can authenticate and connect directly to your desired SQL server. The great thing about it is that you can wrap an entire query written in SQL with a triple quote string directly within your python script. The module will be able to send the query out using the relevant ODBC driver on your machine.

The pyodbc set-up can be generalised because you only need two inputs: the server name and the sql query. Therefore I have developed a python utility written which can be imported into any data processing script as a module.


## XlsxWriter - Excel Report Generator For Python

![Excel](/img/logo/excel.jpg#center)


The proliferation of Excel as a standard piece of software has enabled much easier sharing and communication of data. There is no office computer in the world that is not supplied with Excel.

BI tools are also used to communicate and share data accross the business. However, this depends on how much the organisation can stretch the budget to license the majority of individuals.

Working inside the Excel ecosystem can help save on the extra overhead. However, **we don't want to be doing any analysis in Excel.**

Why?...

Because it's extremely computationally expensive to handle large data sets. And its next to useless when stringing together a series of complex formulas to analyse data.

How can we solve this issue? Simple -- Xlsxwriter.

Xlsxwriter is a python module which allows you to create fresh Excel reports from scratch with analysis conducted in Python. You can turn all your pandas dataframes into Excel tables. Additionally, matplotlib charts can be inserted into the workbook to act as the visualisation component.

With a bit of effort, you can easily turn the analysis into a dashboard that mimics the appearance of an Excel spreadsheet. I frequently use this tool to get dashboards into production quickly with python.

***Note:** XlsxWriter as the name suggests "writes Excel Workbooks". To be clear, this is not an API that can directly interact with objects of pre-existing workbooks. Everytime you execute a script with xlsxwriter tools involved, a completely new file will be produced and overwrite the previous version.*

## Python-Pptx - PowerPoint Presentation Generator For Python

![Powerpoint](/img/logo/pptx.png#center)

How many hours do you waste making powerpoints? I've spent countless hours adjusting trivial features such as formatting or chart positioning.

*But what if the presentation content and design can be prepared automatically?*

I generate tens of presentations per month to cater to multiple stakeholders. Given that I have fairly standardised slide content, this makes presentations a high value automation target for myself.

I've experimented with markdown presentation tools. However, I run into a lot of issues where I do not have full positional control of the objects.

Stakeholders tend to ask for extra features or to move shapes around the slide. However, this is happens to be the power of python-pptx library.

Python-pptx is much more powerful in controling the powerpoint design in comparison to letting markdown dictate all the default positions of your powerpoint shapes.

The control of the objects is very granular its therefore very important to set up functions to standardise some layouts or shapes you want to insert. This speeds up the presentation building process as usually slides tend to borrow a lot of the same code.

The powerpoint functions I write are imported from a seperate .py file. A global function file helps us share the functions to any python script involving presentation automation.

***Note:** Python-pptx works in similar fashion to xlsxwriter. Everytime the script is run, a brand new presentation file will be built from sratch.*


## Smtplib - Email Automation with Python

![Outlook](/img/logo/outlook.png#center)

Routine emails sent on a recurring basis can be automated using the python library smtplib.

We can borrow the SMTP protocol to send our emails and we can avoid our GUI email environment entirely. Python acts as the interface and can send the email directly.

The script can be designed to have a message template built into itself. Additonally, we can make a list of tuples containing the addresses and attachments you want to send to the respective parties.

By looping over these templates and lists, we can entirely bypass the requirement of building all the components for all the emails.

Tens of emails can be sent out in a matter of seconds.

# Conclusion

Considering the tasks we do daily,weekly and monthly; we can tie our procedures together with an elaborate series of Python tools to save hundreds, if not thousands of hours.

For most organisations, the cost benefit ratio is extremely favourable if automation systems are applied (and maintained) correctly.

The value of your time increases exponentially as you are able to prioritise resources in creating higher quality work.
