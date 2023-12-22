# chesskid-scraping

## Problem

I recently tried to use chesskid.com web UI and noticed that their chess archive does not let me download my chess games.
However I can blowse list of the last 10 games and then try to load next page etc.
Also for each game shown it has a button to switch to game analysis. So I decided to work on a solution to my problem ...

## Solution Plan

I stated with analysis of the XHR network requests that chesskid web UI sends to its backend ...
And I found at least these 2 possibilities:

    curl -X GET 'https://www.chesskid.com/api/v1/games/finished?page=2'

    curl 'https://www.chesskid.com/api/v1/games/11ee9f690fd90fe7a2b9246e96712abc/pgn?category=fast'

More complete reuests for them return list of games by page number (in this case 2)

    {
      "items": [
        {
          "id": "11ee9f690fd90fe7a2b9246e96712abc",
          ...
        },
        {
          "id": "11ee9f6876a98415a2b9246e96712abc",
          ...

and PGN for single game id (in this case 11ee9f690fd90fe7a2b9246e96712abc)

    "[Event \"Live Chess Game: hiddenOopponent vs LeftPowerfulLogic\"]\r\n[Site \"ChessKid.com\"]\r\n[Date \"2023.12.20\"]\r\n[Rated \"Rated\"]\r\n[White \"hiddenOopponent\"]\r\n[Black \"LeftPowerfulLogic\"]\r\n[Result \"0-1\"]\r\n[WhiteElo \"1502\"]\r\n[BlackElo \"1965\"]\r\n[TimeControl \"5|1\"]\r\n[Termination \"LeftPowerfulLogic won by checkmate\"]\r\n\r\n1.e4 Nf6 2.e5 Nd5 3.Bc4 Nb6 4.Bb3 c5 5.d3 Nc6 6.Nf3 Qc7 7.Bf4 g6 8.Bg3 Bg7 9.Qe2 Nd4 10.Nxd4 cxd4\r\n 11.e6 Qc5 12.exf7+ Kf8 13.O-O a5 14.a3 a4 15.Ba2 h5 16.Nd2 d5 17.Nf3 Bg4 18.Rac1 Bh6 19.Rce1 Kxf7 20.h3 Bd7\r\n 21.Ne5+ Ke8 22.Nxg6 Rh7 23.Bh4 Nc8 24.f4 Ra6 25.f5 Be3+ 26.Bf2 Bxf5 27.Nh4 Bd7 28.Bxe3 dxe3 29.Qxe3 Qxe3+ 30.Rxe3 Rb6\r\n 31.Rb1 d4 32.Re4 Bc6 33.Rxd4 Rg7 34.c3 Nd6 35.Rb4 Ra6 36.Rf1 b5 37.Rbf4 Kd7 38.d4 Nc4 39.Bxc4 bxc4 40.Rf7 Rxf7\r\n 41.Rxf7 Rb6 42.Rf2 Be4 43.Kh2 Re6 44.Kg3 Kd6 45.Nf3 Kd5 46.Ng5 Rg6 47.Kh4 Bd3 48.Kxh5 Rb6 49.h4 e5 50.dxe5 Kxe5\r\n 51.Nf3+ Ke4 52.Ne1 Ke3 53.Nxd3 cxd3 54.Rf3+ Ke2 55.c4 d2 56.c5 Rc6 57.Rf2+ Kxf2 58.g4 d1=Q 59.Kg5 Rxc5+ 60.Kh6 Qxg4\r\n 61.Kh7 Rh5# 0-1\r\n",

Then the plan for the draft solution has the following steps:
* get all pages of all games as formatted JSON files;
* get all game ids from all these downloaded JSON files;
* convert game ids to PGNs and then to a single PGN file to use in my local desktop Stockfish program

This solution is half-automated for now and below you will find each step detailed.

## Step 1: download all game archive pages as JSON files

For that I created dl-page.sh script and json-tool.js small program to format the JSON data.
To download all the pages I tried to limit number of then to the range 1..100. 
Beacuase I was sure I has not played more than 1000 games yet on chesskid at least :)
So to download all the game archive I used single command below which triggers dl-page.sh properly:

    mkdir pages
    for i in {1..100} ; do ./dl-page.sh $i ; done

The result of that operation created for me the JSON files inside the "pages" folder:

    Igors-MacBook-Pro:chesskid-scraping igor$ ls pages
    1.json          27.json         45.json         63.json         81.json
    10.json         28.json         46.json         64.json         82.json
    ...

Then I analysed them manually a bit and noticed that all the files starting 
from number 26 have no game info inside, so only 25 of them have been useful.

## Step 2: retrieve all game ids from the downloaded JSON files

This step is important because we need those ids to further retrieve PGN data (list of moves for the games) for each game.

Here I created and used get-ids.sh script. Running that script produces "results/ids.txt" file which has all the game ids.
And I used page numbers in range 1..25

    mkdir results
    for i in {1..25} ; do ./get-ids.sh pages/$i.json ; done

The results/ids.txt then looks as follows:

    Igors-MacBook-Pro:chesskid-scraping igor$ head -n 3 results/ids.txt
    11ee9f690fd90fe7a2b9246e96712abc
    11ee9f6876a98415a2b9246e96712abc
    11ee9f67ebc8b068a2b9246e96712abc

In total then I played 248 games. Maybe 1st few were played by my wife, cause I used her chesskid account :)

    Igors-MacBook-Pro:chesskid-scraping igor$ cat results/ids.txt | grep -c ""
    248

## Step 3: convert all game ids to JS file with array of PGN strings

For this I created get-pgns-array.sh and get-pgn.sh scripts.
They both have its own responsibility. The get-pgn.sh can download sibgle PGN string for one game id.
The get-pgns-array.sh script is an orchestrator script that reuses get-pgn.sh script to download all PGN string for all game ids and produce the JS file.
To trigger this step it is enough to run the get-pgns-array.sh script file which produces the results/pgns-raw.js file with array of sctrings inside:

    module.exports = [
    "[Event...",
    ...
    "[Event...",
    ];

## Step 4: convert the results/pgns-raw.js to results/all.pgn

Here I created goal.js program that gets the job done.

    node goal

This produces results/all.pgn which we can use inside the Stockfish program to browse those games and run the strongest possible computer analysis.

    [Event "Live Chess Game: hiddenOopponent vs LeftPowerfulLogic"]
    [Site "ChessKid.com"]
    [Date "2023.12.20"]
    [Rated "Rated"]
    [White "hiddenOopponent"]
    [Black "LeftPowerfulLogic"]
    [Result "0-1"]
    [WhiteElo "1502"]
    [BlackElo "1965"]
    [TimeControl "5|1"]
    [Termination "LeftPowerfulLogic won by checkmate"]

    1.e4 Nf6 2.e5 Nd5 3.Bc4 Nb6 4.Bb3 c5 5.d3 Nc6 6.Nf3 Qc7 7.Bf4 g6 8.Bg3 Bg7 9.Qe2 Nd4 10.Nxd4 cxd4
     11.e6 Qc5 12.exf7+ Kf8 13.O-O a5 14.a3 a4 15.Ba2 h5 16.Nd2 d5 17.Nf3 Bg4 18.Rac1 Bh6 19.Rce1 Kxf7 20.h3 Bd7
     21.Ne5+ Ke8 22.Nxg6 Rh7 23.Bh4 Nc8 24.f4 Ra6 25.f5 Be3+ 26.Bf2 Bxf5 27.Nh4 Bd7 28.Bxe3 dxe3 29.Qxe3 Qxe3+ 30.Rxe3 Rb6
     31.Rb1 d4 32.Re4 Bc6 33.Rxd4 Rg7 34.c3 Nd6 35.Rb4 Ra6 36.Rf1 b5 37.Rbf4 Kd7 38.d4 Nc4 39.Bxc4 bxc4 40.Rf7 Rxf7
     41.Rxf7 Rb6 42.Rf2 Be4 43.Kh2 Re6 44.Kg3 Kd6 45.Nf3 Kd5 46.Ng5 Rg6 47.Kh4 Bd3 48.Kxh5 Rb6 49.h4 e5 50.dxe5 Kxe5
     51.Nf3+ Ke4 52.Ne1 Ke3 53.Nxd3 cxd3 54.Rf3+ Ke2 55.c4 d2 56.c5 Rc6 57.Rf2+ Kxf2 58.g4 d1=Q 59.Kg5 Rxc5+ 60.Kh6 Qxg4
     61.Kh7 Rh5# 0-1
