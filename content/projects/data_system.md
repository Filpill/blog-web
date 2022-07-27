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
I'm always suprised by organisations which are not investing resources into automating their processes.

Yes, large organisations are complex and sprawling in nature. However, I am always spotting oppertunities to streamline processes and alleviate the burden from our day to day work.

This article serves as an example for the wide ranging applications I've been using Python to automate both simple and complex tasks with high efficiency.

# An Idealistic Data Processing System

These are the ideal goals we are trying to achieve:

- To build complete end-to-end solutions from source to user.
- We want to minimise manual intervention during the data processing.
- Build tools which are adaptable according to buisness needs.

Here is a very high level view of a system of data pipelines I've built in the past:
{{<mermaid>}}
graph TD;
    subgraph <br><br><br>&nbsp; Data Processing <br>and Manipulation
    A[Shell Scripts]-- terminal/<br>cli tools -->B(Core Driver:<br> Python Scripts)
    C[(SQL Server)]-- pyodbc -->B
    end
    subgraph Data Products
    B-- xlsxwriter -->D(Excel Dashboards)
    B-- python-pptx -->E(Powerpoint Presentations)
    B-- smtplib -->F(Emails via SMTP)
    end
{{< /mermaid >}}

This is by no means a definative method and sometimes we can't get away from 100% of tedious tasks. However, this is just the result of incremental upgrades made across the board to optimise my processes in the past. I've had a lot of success inter-weaving these tools together purely through experimentation of various python libraries available.

As long as the tools are well written, you can bridge them across to new processes easily and maintain them with little to no effort. Not to mention the hunderds to thousands of hours being saved as you execute these processes..

The idea is not to replicate this system one-to-one, but to inspire a systems level appreciation for connecting automation tools togther in a well thought out manner.



## PyODBC - A SQL Interface For Python

![SQL](/img/logo/sql.png#center)

The most important setup of the automation process is the data ingestion into Python.

Fortunately for myself, our organisation hosts several Microsoft SQL Servers which form our data source.

PyODBC is a python module which enables the capability to authenticate and connect directly to your desired SQL server. The great thing is that you can copy an entire query written in SQL and paste it into a triple quote string of a python script. The module will be able to interpret the string as a SQL query.

Much of the pyodbc set-up can be universalised because realistically you only need two inputs: the server name and the sql query. Therefore I have developed a sql utility written in an independant python file which can be imported into any script.

## XlsxWriter - Excel Report Generator For Python

![Excel](/img/logo/excel.jpg#center)


There is a reason why Excel reigns as a supreme data communication tool. It's proliferation as a standard piece of software. There is no office computer in the world that is not supplied with Excel.

Sure, we could be using BI tools to communicate and share data. However, this completely depends on the company budget and how much the organisation can stretch the licensing to individuals.

Ok, so we deciding to work inside the Excel ecosystem as it will not incur any extra overhead.

However, we don't want to be doing our analysis in Excel...Why? Because it's extremely computationally expensive to handle medium to large data sets. And its next useless when stringing together lots of complex formulas with the large data size.

So how can we solve this issue? Simple. XlsxWriter.

XlsxWriter is a python module which allows you to create fresh Excel reports from scratch with analysis performed on Python. Essentially you can turn all your pandas tables Excel table objects. All your matplotlib charts can be inserted into the workbook for the visualisation. Furthermore, with a bit more effort, you can easily turn it into a dashboard.

Now it can be easily share amongst the stakeholders. I've been using this tool many a time to get excel boards out quickly with python.

***Note:** XlsxWriter as the name suggests "writes Excel Workbooks". To be clear, this is not an API that can directly interact with objects in existing workbooks. Everytime you run a script with xlsxwriter tools involved, a completely new file will be producing and overwrite the previous one.*

## Python-Pptx - PowerPoint Presentation Generator For Python

![Powerpoint](/img/logo/pptx.png#center)

How many hundreds of hours do you waste making powerpoints? Probably too many. Though this is a big target for automation if the slide content is very standardised across different periods of time.

I've tried automating them with markdown tools. However, I run into a lot of issues where I do not have full control over the position of the objects. Stakeholders tend to ask for extra features or to move shapes around the slide. Thats where python-pptx comes in.

Instead of letting markdown dictate all the default positions of your powerpoint shapes. I've been automating all my presentations with Python-pptx.

Since the control of the objects is very granular its important to set up some functions to standardise some layouts or shapes you want to insert. This speeds up the scripting process as usually slides tend to have a lot of the same code and all we need to do is change some parameters.

The powerpoint functions I write are imported from a seperate .py file. The reason we ideally want a global function file is that we can share these python function to any script where we are automating presentations.

***Note:** Python-pptx works in similar fashion to xlsxwriter. Everytime the script in run, a brand new presentation file will be build from sratch. We are not interacting with existing pptx objects on existing presentations.*


## Smtplib - Email Automation with Python

![Outlook](/img/logo/outlook.png#center)

For those routine emails that you send on a recurring basis you able to automate the process using the python library smtplib.

We can borrow the SMTP protocol to send our emails and we don't necessarily need to be tied to our GUI standard email environment. We can use python as the interface and send emails without gmail or outlook.

The script that is being generated can have a message template built inside itself. Additonally can make a list of tuples containing the addresses and attachments you want to send to the respective parties.
