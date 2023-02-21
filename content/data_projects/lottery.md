---
title: "Python Lottery Game"
date: 2023-02-18
draft: true
ShowToC: False

cover:
  image: img/lottery/lottery_hugo.png
  alt: "Lottery Banner"

tags: [python]
categories: [programming]

---

# Summary

***A game where you test your luck:*** *Pick some numbers and try to win!*

Link to github project: https://github.com/Filpill/lottery-game

## Lottery Algorithm

{{<mermaid>}}
flowchart TD;

subgraph Lottery Algorithm
  start(Pick \nLottery Numbers) --Check--> check{Are the \ninputs valid?}
  check --Yes--> draw[Generate Randomised\nLottery Draw]
  check --No--> start
  draw --> match{Do Picks Match the\n Lottery Draw?}
  match --Yes--> win(Winner!)
  match --No--> reroll[Chance to reroll\nthe incorrect numbers]
  reroll --> check2{Did you hit any\n more correct picks?}
  check2 --No--> lost(Loser!)
  check2 --Yes--> check3{Are they\n all matching?}
  check3 --No--> reroll
  check3 --Yes--> win
end

{{< /mermaid >}}