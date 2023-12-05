---
title: "Codewars API - User Statistics"
description: "Extracting codewars userdata and analysing metrics on Python"
date: 2022-11-09
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: img/codewars/codewars-stats.png
  alt: "Codewars Stats Image"

categories: [Data]
---

# Summary

I've been very involved in practising my programming skills in python and sql lately on codewars.

I figured it would be a good idea to visualise my codewars progression.

I'm utilising the codewars public API to pull out my information. The user data is processed in Python with the output being consolidated into a Excel dashboard using Xlsxwriter.

Link to github project: https://github.com/Filpill/codewars-stats

## Analytics Process Flow

{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0([Python Notebook Executed])-->A[HTTPS Request Codewars <br>Username Stats]
    end

    subgraph Return JSON
    A-->C[Username Profile <br>Data]
    A-->D[List of Compeleted <br>Kata by User]
    A-->E[Individual Challenge <br>Details]
    end

    subgraph Merge Data
    D-->F[Merge Data via the Kata ID]
    E-->F
    F-->G[Re-name Columns to Better Format]
    end

    subgraph Count Aggregates
    G-->H[Categories]
    G-->I[Monthly Completions]
    G-->J[Kata Rank]
    G-->K[Languages]
    end

    subgraph Visualisation
    H-->L[Graphing Cats.]
    I-->M[Graphing Comp.]
    J-->N[Graphing Rank.]
    K-->O[Graphing Lang.]
    end

    C-->P

    subgraph XlsxDashboard
    L-->P[Insert and Format Tabular Data]
    M-->P
    N-->P
    O-->P
    P-->Q[Insert Matplotlib Charts]
    Q-->R([Close Xlsxwriter Workbook Object])
    end
{{< /mermaid >}}

## Data Visualisations

These images are served directly from my github repository:

![test](https://raw.githubusercontent.com/Filpill/codewars-stats/main/charts/rank_distribution.png) | ![test](https://raw.githubusercontent.com/Filpill/codewars-stats/main/charts/language_pie.png)
| :--------: | :----------: |

 ![test](https://raw.githubusercontent.com/Filpill/codewars-stats/main/charts/top_tags.png) |  ![test](https://raw.githubusercontent.com/Filpill/codewars-stats/main/charts/monthly_complete_barh.png)
| :--------: | :----------: |
