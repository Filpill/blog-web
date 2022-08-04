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

I am always spotting oppertunities to streamline processes and alleviate the burden from our day to day work.

This article serves as an example for the wide ranging applications I've been using Python to automate both simple and complex tasks with high efficiency.

# Data Transformation & Processing System

These are some of the goals we are trying to achieve:

- To build complete end-to-end data solutions from source to user.
- We want to minimise manual task inputs during the data processing.
- Build tools which are adaptable according to business needs.

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

***Note**: Python scripts are chained at different levels to connect the processes together and handle various tasks along the pipeline*

This is the result of incremental upgrades made gradually over time to optimise my processes in the past. I've had a lot of success inter-weaving these tools together through experimentation of the various python libraries available.

As long as the tools are well written, you can bridge them across to new processes easily and maintain them with little to no effort. Not to mention the hundreds to thousands of hours being saved as you execute these processes.

The idea is not to replicate this system one-to-one, but methods for connecting automation tools togther in a well thought out manner that serves both the analyst and the end-user.



## PyODBC - A SQL Interface For Python

![SQL](/img/logo/sql.png#center)

The most important setup of the automation process is the data ingestion into Python.

Fortunately for myself, our organisation hosts several Microsoft SQL Servers which form part of our data warehouse.

PyODBC is a python module which enables the capability to authenticate and connect directly to your desired SQL server. The great thing is that you can wrap an entire query written in SQL with a triple quote string of a python script. The module will be able to interpret the string as a SQL query.

Much of the pyodbc set-up can be generalised because you only need two inputs: the server name and the sql query. Therefore I have developed a sql utility written in an independant python file which can be imported into any data processing script.

## XlsxWriter - Excel Report Generator For Python

![Excel](/img/logo/excel.jpg#center)


The proliferation of Excel as a standard piece of software has enabled much easier sharing and communication of data. There is no office computer in the world that is not supplied with Excel.

We could potentially use BI tools to communicate and share data. However, this completely depends on how much the organisation can stretch the budget to license the majority of individuals.

Deciding to work inside the Excel ecosystem can save on the extra overhead. However, **we don't want to be doing any analysis in Excel.**

Why?...

Because it's extremely computationally expensive to handle medium to large data sets. And its next to useless when stringing together a series of complex formulas for large datasets.

So how can we solve this issue? Simple - with Xlsxwriter.

Xlsxwriter is a python module which allows you to create fresh Excel reports from scratch with analysis performed on Python. Essentially you can turn all your pandas dataframs into Excel table objects. Additionally all your matplotlib charts can be inserted into the workbook for the visualisation component. With a bit of effort, you can easily turn it into a dashboard that mimics the appearance of an Excel spreadsheet.

You can easily share the resulting excel file amongst the stakeholders. I frequently use this tool to get excel dashboards into production quickly with python.

***Note:** XlsxWriter as the name suggests "writes Excel Workbooks". To be clear, this is not an API that can directly interact with objects of existing workbooks. Everytime you run a script with xlsxwriter tools involved, a completely new file will be producing and overwrite the previous one.*

## Python-Pptx - PowerPoint Presentation Generator For Python

![Powerpoint](/img/logo/pptx.png#center)

How many hundreds of hours do you waste making powerpoints? Probably too many. They are normally boring, tedious and mind-numbing tasks (for somebody who makes tens of presentations per month).

This is a big automation target if the slide content is fairly standard across time periods.

I've tried automating them with markdown tools. However, I run into a lot of issues where I do not have full control over the position of the objects.

Stakeholders tend to ask for extra features or to move shapes around the slide. However, this is happens to be the power of python-pptx library.

Instead of letting markdown dictate all the default positions of your powerpoint shapes. I've been automating all my presentations with Python-pptx.

The control of the objects is very granular its important to set up functions to standardise some layouts or shapes you want to readily insert. This speeds up the scripting process as usually slides tend to borrow a lot of the same code.

The powerpoint functions I write are imported from a seperate .py file. Ideally we want a global function file such that we can share the functions to any python script involving presentation automation.

***Note:** Python-pptx works in similar fashion to xlsxwriter. Everytime the script is run, a brand new presentation file will be built from sratch.*


## Smtplib - Email Automation with Python

![Outlook](/img/logo/outlook.png#center)

For those routine emails sent on a recurring basis you will able to automate the process using the python library smtplib.

We can borrow the SMTP protocol to send our emails and we can avoid our GUI email environment entirely. Python acts as the interface and send emails without gmail or outlook platforms.

The script can have a message template built inside itself. Additonally, we can make a list of tuples containing the addresses and attachments you want to send to the respective parties.

Looping over these templates and lists, we can entirely bypass the requirement of building each component of each email.

We can fire off tens of emails out in a matter of seconds.

# Conclusion

Considering the tasks we do daily,weekly and monthly; we can tie our procedures together with an elaborate series of Python tools to save hundreds, if not thousands of hours.

For most organisations, the cost benefit ratio is extremely favourable if automation systems are applied (and maintained) correctly.

The value of your time will increase exponentially as you are able to prioritise resources towards increasing the quality of your work.

You will have a higher capacity to produce more impactlful results without tedious tasks weakening your focus on quality.
