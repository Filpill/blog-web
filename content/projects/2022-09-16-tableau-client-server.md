---
title: "Tableau Client Server API: Extracting Dashboard Images"
date: 2022-09-16
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
draft: false
ShowToC: true

cover:
  image: /img/tableau/tableau_py.png
  alt: Tableau Client Server API with Python

categories: [Data]

---

# Summary

I've been in the process of developing numerous Tableau dashboards across different areas of the airline business to share safety data across the organisation.

However, there is no easy way to download all the various charts from dashboard views you have produced to recycle for the purpose of a powerpoint presentation.

Ideally we want to avoid duplicating the data analytics process in other systems such as Python as we don't want to incur uncessary work to present the same information.

The Tableau Client Server API helps solve this issue by enabling us to programatically extract dashboard images in an effcient manner.

## Process Overview

- iPython/Jupyter Notebook Connecting to the Tableau Client Server API with personal access token.
- Collating all Projects and Views into table and utilising view id's to extract dashboard images in conjunction with Pandas.
- Dashboard images cropped down to chart dimensions with a Python Image Library prepare image for presentation use.

Link to the project here: [Tableau Dashboard Image Extraction Notebook](https://github.com/Filpill/Tableau-DashExtract)

## Tableau Client Server API Workflow

{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0([Python Notebook Executed])-->A[Personal Access Tokens: <br>Authenticating Valid API Connection<br> with Tableau Server]
    end

    subgraph Get Requests: Server Object ID's
    A-->C[Gathering <br>Project ID's]
    A-->D[Gathering <br>Workbook ID's]
    A-->E[Gathering <br>View ID's]
    end

    subgraph Combine &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data
    C-->F[Merging ID Info into Single Pandas DataFrame]
    D-->F
    E-->F
    F-->G[Filtering DataFrame to Selected Project ID]
    G-->H[Collecting List of Server View Objects]
    end

    subgraph Process &nbsp;&nbsp;&nbsp;&nbsp;Images
    H-->I[Saving all the Images of View Objects]
    I-->J[Python Image Library<br>Crop Images to Correct Dimensions]
    J-->K([Save Cropped Dashboard Images])
    end
{{< /mermaid >}}

## Conclusion

As you can see, the process for extracting the Tableau image data from dashboards is fairly straightforward.

With the View ID, you are able to extract the full dashboard image. The only drawback is that there is no way to pull out the individual charts from the dashboard view via this API. Therefore you need to specify all the pixel dimensions to crop the images into their respective charts.

The only alternative is to implement a web-scraping technique on Tableau Server and figure out a way to pull down the chart data. It would probably require something like Selenium because of the dynamic nature of the website.

Regardless, with the Tableau Client Server API you will still benefit from the dashboard image extraction in addition to allowing you to repurpose your existing dashboards for presentation purposes.
