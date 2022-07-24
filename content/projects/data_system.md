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

How much time do you waste making powerpoints? Probably too many.

I've tried making them with markdown tools. However, I run into a lot of issues where I do not have full control over the position of the objects. Thats where python-pptx comes in.

I've been automating all my presentations with Python-pptx

![Powerpoint](/img/logo/pptx.png#center)

## Outlook - Email Automation with Python

If you want to go full lazy mode, you can make a list of tuples containing the addresses and attachments you want to send. Naturally as per the theme of this post, these lists can automatically be sent with Python.

![Outlook](/img/logo/outlook.png#center)
