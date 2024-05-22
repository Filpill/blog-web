---
title: "Airspace Tracking Visualisations"
description: "Retrieving airspace states via OpenSky REST API and animating data using Python + FFMPEG"
date: 2024-05-05
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: ./img/flight/airspace_visualiser.png
  alt:

tags: [📊 Data]
---

## Summary
This article will quickly show you the process of how I obtained the world airspace data using the OpenSky REST API and how I was able to visualise the data. But I will focus on North American airspace since it seems to be the region that captures the most aircraft.

The link to my ["flight_tracking" GitHub project is here](https://github.com/Filpill/flight_tracking) should you wish to peruse the scripts I've created.

The totality of the airspace depends much maintenance of the OpenSky network. The majority of the data is recorded via ADS-B receivers, which are distributed over the land mass. 

I'm not too well acquainted with aircraft surveillance, but I presume we lose visibility of aircraft (in the data) as they fly out of range of ground stations over the sea or mountainous regions. Otherwise it would be interesting to monitor the full flight path across the globe.

Aircraft also require a transponder to provide GPS data to the receivers. Any flying aircraft with no transponder are not being captured in this view.

I am sure there are more accurate flight data providers selling more accurate views and better coverage, but this is purely an illustrative exercise for curiosities sake.

## Timelapse Video
Here is a video illustrating a 16-hour time-lapse of a scatter plot of aircraft flying over North America.
{{< youtube wC3WE-jOU0w >}}

## Processes and Procedures

I'll go through details of my data collection, storing and processing.

I've considered creating a database and dumping the results in there, but this is something I'll consider in a future iteration if we decide to have a more long-term permanent data collection solution.

This going to be a fairly quick and dirty version, however, I still ensure there is a semblance of structure in the folders storing the data.

### Overall View
The workflow looks something like this:
1. Store raw csv data - collection of csv partitioned by date
2. Process image data - split collection by visualisations e.g.: contourf, quiver, scatter etc.
3. Post-process data - image re-sizing and cropping data to final dimensions
4. Animate collection of processed images - using ffmpeg shell script

### Data Collection
This is the overall process of how the data is collected:
1. Create Python script to request airspace state every 60s
2. Recursively store the aircraft positions in a list individual timestamped csv's
3. Actually it's as simple as that.

The time delta between each snapshot not too large to lose detail in the movements and not too small to overload the API with requests. The latter is probably more important to consider, because you don't want to bombard the API and risk taking it completely out of commission due to high frequency request intervals.

Something that is important to note is that anonymous users are limited to 80 requests to the OpenSky API per day. This is no good for us since we are trying to make a time lapse over an extended period of time. 

We can circumvent this issue by using rotating IP addresses, since each API call will be distributed over a pool of IP addresses and thus prevent our request timing out (since they can't pin down our real IP identity).

Though this methodology is typically requires the use of a paid service to provide high quality proxies. In my scenario, I chose to use **OxyLabs** which have a web scrapping proxy tool. You can pipe you Python request via their proxy it will automagically handle the proxies for you. I was able to run my script overnight with not a single failure and retrieved over 850 requests.

Each request produces a 1.1MB csv file. So over 16 hours, we were able to hoover about 1GB of data all together. Unfortunately, my script crashed in the late stages of the execution (probably because I was running it out of a jupyter notebook). I'll convert it into a Python script another time, it just so happens its easier to read the data in Jupyter when doing data exploration.

### Data Visualisation

Part of the inspiration of the visualisation is that I imagine the aircraft movements would have a strong resemblance to a "fluid displacement" in a aero/mechanical context. So I just wanted to explore the 2D visualisation options and see if this is true.

*to be continued*


### Data Animation

This segment is fairly straightforward. Using **ffmpeg**, we can simply point to a folder with a collection of images and ask the program to splice them together into a mp4 file.

As long as all the images are timestamped, the files should be sorted in chronological order so you don't need to fiddle with passing additional sort arguments into your command.

It only takes a few minutes on my machine to splice together 850 images together.

*to be continued*
