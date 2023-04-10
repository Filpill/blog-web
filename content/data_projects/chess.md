---
title: "Chess.com API - Data Visualisation"
date: 2023-04-10
draft: true

cover:
  image: /img/chess/chess_gimp.png
  alt: Chess Data Analysis Image Cover

tags: [python,data,programming,webscraping]
categories: [data]

---

# Summary

I've played a decent number of chess games on the chess.com platform since 2019 and all my chess data can be explored using the API endpoints documented inside the website.

I was interested in monitoring my rating change over the cumalative number of games played.

Link to the project here: [Chess.com - Python Analysis](https://github.com/Filpill/chess_analysis)


## Analytics Process Flow

{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0([Python Notebook Executed])-->A[HTTPS Request Chess <br>Username Stats]
    end

    subgraph Data Extraction
    A-->B[Requesting List of <br>Month Endpoints]
    B-->C[Request List Games <br>For Each Month Endpoint]
    C-->D[Unpack all Games <br>into Dataframe]
    end

    subgraph Data Cleaning
    D-->E[Filtering to <br>Blitz Chess Games]
    E-->F[Cleaning pgn Chess data<br>and Merging Additional Attributes]
    F-->G[Extracting Player Ratings<br>and Game Results]
    G-->H[Curating List of Columns]
    end

    subgraph Data Aggregation
    H-->J[Top Openings]
    H-->K[Time of Day]
    H-->L[Monthly Volume]
    H-->M[Game Result]
    end

    subgraph Visualisation
    J-->N[Graphing Openings]
    K-->O[Graphing Time of Day]
    L-->P[Graphing Monthly Volume]
    M-->Q[Graphing Game Result]
    end

    subgraph XlsxDashboard
    N-->R[Insert and Format Tabular Data]
    O-->R
    P-->R
    Q-->R
    R-->S[Insert Matplotlib Charts]
    S-->T([Close Xlsxwriter Workbook Object])
    end
{{< /mermaid >}}

















































## Data Visualisations

![Rating](/img/chess/raw_rating_line.png#center)
![Moving Average Rating](/img/chess/avg_rating_line.png#center)
![Top Openings](/img/chess/top_openings.png#center)
![Time of Day](/img/chess/time_of_day.png#center)
![Day of Week](/img/chess/day_of_week.png#center)
![Chess Summary](/img/chess/chess_summary_pie.png#center)
![Monthly Games](/img/chess/monthly_games.png#center)
