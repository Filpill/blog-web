---
title: "{{ replace .Name "-" " " | title }}"
description: "--- Insert Description Here ---"
date: {{ .Date }}
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: ./img/folder_name
  alt:

tags: [💻 Systems, ⚙️ Engineering, 📊 Data]

---

{{<mermaid>}}
graph TD;
    subgraph Process Initiation
    0([Process Start])-->A[Step 1]
    end
{{</mermaid>}}

