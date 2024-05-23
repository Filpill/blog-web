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

> [Flight Tracking GitHub Project link](https://github.com/Filpill/flight_tracking) is here should you wish to peruse the scripts I've created and get some context of my commentary in this article.

The totality of the airspace depends much maintenance of the OpenSky network. The majority of the data is recorded via ADS-B receivers, which are distributed over the land mass. 

![ADS-B Infographic](https://global.discourse-cdn.com/infiniteflight/original/4X/c/e/8/ce82d1b284d206ad24e395beaf56a63209fbee15.jpeg)

I'm not too well acquainted with aircraft surveillance, but I presume we lose visibility of aircraft (in the data) flying over the sea or mountainous regions outside the range of ground stations. Otherwise it would be interesting to monitor the full flight path across the globe.

Aircraft also require a transponder to retrieve GPS data i.e. communicating between satellites and ground stations. Any flying aircraft with no transponder are not being captured in this view.

I am sure there are more accurate flight data providers selling more accurate views and better coverage, but this is purely an illustrative exercise for curiosities sake.


## Processes and Procedures

I'll go through details of my data collection, storing and processing.

This going to be a fairly quick and dirty version, however, I still ensure there is a semblance of structure in the folders storing the data. Long-term we can look at dumping this info into database like SQLite or Postgres.

### Overall View
The workflow looks something like this:

{{<mermaid>}}
graph LR;
    classDef blue fill:#2374f7,stroke:#8ec1f5,stroke-width:7px, color:#fff,stroke-dasharray: 4 1
    classDef yellow fill:#e6d00b,stroke:#f5eb5b,stroke-width:7px, color:#000,stroke-dasharray: 4 1
    classDef green fill:#10ad0a,stroke:#7feb4d,stroke-width:7px, color:#000,stroke-dasharray: 4 1
    classDef red fill:#db3b1f,stroke:#eb654d,stroke-width:7px, color:#fff,stroke-dasharray: 4 1

    1([1. Request aircraft positions]):::blue --o 2([2. Store raw csv]):::yellow--o3([3. Process images]):::green--o4([4. Create Video]):::red

    linkStyle 0 stroke:#8ec1f5,stroke-width:11px
    linkStyle 1 stroke:#f5eb5b,stroke-width:11px
    linkStyle 2 stroke:#7feb4d,stroke-width:11px
{{</mermaid>}}


<p style="color:blue;">
    some *blue* text
</p>

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

I think the most interesting component to visualising this data is that we are able to clearly see the density of air traffic flying in various airspace. 

We can see common commercial flight routes and we can also see the airport hubs where these air traffic networks are connecting. And there is a multitude of ways to visualise this information, all the way from a contourf plot to a quiver plot. Various 2D visualisations will reveal different information about air traffic behaviour, so it's good to compare and contrast.

Available GPS Data sourced from OpenSky API:
- Longitude
- Latitude
- Speed Bearing
- Various other data points including callsigns.

However, if we are considering a quiver plot, we need to split the speed into its horizontal and vertical components, so we can do some trig to figure that out.

And when considering 2D visualisation like contourf for example, it is necessary to create a "meshgrid" over the plot. Since the aircraft could be between spaces on the grid, we would need to interpolate to retrieve aircraft speed. After this is done a contour plot is straightforward.

The only outstanding component is the generating the map so we can see the geography of the continent. I've chosen to use the **Stadia Maps** API to retrieve the map data in my preferred styling. 

Although I came across some issues since each API call for the mapping data costs credits to use. And since the map is completely static, it doesn't make sense to make multiple API calls for each set of data from a cost perspective.

Even from a time perspective, it takes a very long time to render the map, about 13s for each snapshot which is way too long. Instead, the process I have created is to only clear the data "artists" on the matplotlib figure whilst retaining the map image on the plot. Plotting the datapoints takes a trivial amount of time in comparison (about 1s or so per iteration).

The plotting process is iterated and entire folder of timestamped csv's to generate the aircraft movement visualisations incrementally over time.

### Data Animation

And this is the key component where we can physically see how the aircraft are moving over time.

This animation procedure is fairly straightforward when using **ffmpeg**. We can simply point to a folder with a collection of images and ask the program to splice them together into a mp4 file (or whatever file type).

As long as all the images are timestamped, the files should be sorted in chronological order so you don't need to fiddle with passing additional sort arguments into your command.

It only takes a few minutes on my machine to splice together 850 images together.

Since my file structure is segmented into multiple folders partitioned by "date" and "visualisation type", I simply pass those parameters into my bash script to generate the spliced video.

Other video processing I did audio-wise was done on Kdenlive to add in the musical audio transitions.

## Timelapse Video
Here is a video illustrating a 16-hour time-lapse of a scatter plot of aircraft flying over North America.
{{< youtube wC3WE-jOU0w >}}
