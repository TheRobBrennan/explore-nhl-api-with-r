# Welcome

This example will explore getting started developing with the [R](https://www.r-project.org) programming language as quickly as possible using [RStudio](https://posit.co/products/open-source/rstudio/) and data from the Western Hockey League (WHL) API.

![](./assets/welcome.png)

## Scratchpad

Tonight's train of thought:
- [2023.02.11 Sat - Seattle Thunderbirds at Portland Winterhawks](https://whl.ca/gamecentre/1019157)
  - What network calls are being made behind the scenes for this game?
    - WHL Scorebar - [https://lscluster.hockeytech.com/feed/index.php?feed=modulekit&key=41b145a848f4bd67&site_id=2&client_code=whl&lang=en&view=scorebar&numberofdaysahead=3&numberofdaysback=0&league_code=&fmt=json](https://lscluster.hockeytech.com/feed/index.php?feed=modulekit&key=41b145a848f4bd67&site_id=2&client_code=whl&lang=en&view=scorebar&numberofdaysahead=3&numberofdaysback=0&league_code=&fmt=json)
    - Example 2 - [https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=preview](https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=preview)
    - Example 3 - [https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=pxpverbose](https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=pxpverbose)
    - Example 4 - [https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=clock](https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=clock)
    - Example 5 - [https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=gamesummary](https://cluster.leaguestat.com/feed/index.php?feed=gc&key=41b145a848f4bd67&client_code=whl&game_id=1019157&lang_code=en&fmt=json&tab=gamesummary)

Shoutout to [Jonathas Ribeiro](https://github.com/jonathas) for providing an excellent example [hockeytech](https://github.com/jonathas/hockeytech/blob/develop/index.js) Node.js module on [GitHub](https://github.com/jonathas/hockeytech/blob/develop/index.js) to help shine a light on some additional possibilities for the [HockeyTech](https://www.hockeytech.com) API.

Let's look at each of the example calls above to see what we have.

### What network calls are being made behind the scenes for this game?
Following tonight's train of thought, let's take a peek and see what data we're working with after the conclusion of tonight's game.

#### WHL Scorebar
This is our lone Module Kit example - with a reference JSON data response available for review at [](./__reference/whl_scorebar.json)

#### Example 2
This example contains a reference JSON data response available for review at [example-2.json](./__reference/example-2.json)

#### Example 3
This example contains a reference JSON data response available for review at [example-3.json](./__reference/example-3.json)

#### Example 4
This example contains a reference JSON data response available for review at [example-4.json](./__reference/example-4.json)

#### Example 5
This example contains a reference JSON data response available for review at [example-5.json](./__reference/example-5.json)
