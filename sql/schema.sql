create table if not exists game (
    gamePk integer primary key, 
    gameDate timestamp with time zone,
    officialDate date,
    sportId integer,
    gameType VARCHAR(1),
    codedGameState varchar(1),
    detailedState varchar(100),
    awayteamid integer,
    awayteamname varchar(100),
    awayteamscore integer,
    hometeamid integer,
    hometeamname varchar(100),
    hometeamscore integer,
    venueid integer,
    venuename varchar(100),
    scheduledInnings integer
);

create table if not exists linescore (
    gamepk integer REFERENCES game,
    inning INTEGER,
    half INTEGER,
    battingteamid INTEGER,
    runs INTEGER,
    hits INTEGER,
    errors INTEGER,
    leftonbase INTEGER,
    battingteam_score INTEGER,
    battingteam_score_diff INTEGER,

    primary key (gamepk, inning, half, battingteamid)
);

create table if not exists runner_play (
    gamepk integer references game,
    atbatindex integer,
    playindex integer,
    playid uuid,
    runnerid INTEGER, 
    runnerfullname varchar(50),
    startbase varchar(5),
    endbase varchar(5),
    reachedbase varchar(5),
    is_out BOOLEAN,
    eventtype VARCHAR(100),
    movementreason VARCHAR(100),
    is_risp BOOLEAN,
    is_firsttothird BOOLEAN,
    is_secondtohome BOOLEAN,

    primary key (gamepk, atbatindex, playindex, runnerid)
); 

