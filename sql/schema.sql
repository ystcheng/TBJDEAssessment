drop table game cascade;
create table if not exists game (
    gamePk integer primary key, 
    gameDate timestamp with time zone,
    officialDate date not null,
    sportId integer not null,
    gameType VARCHAR(1) not null,
    codedGameState varchar(1),
    detailedState varchar(100),
    awayteamid integer not null,
    awayteamname varchar(100),
    awayteamscore integer,
    hometeamid integer not null,
    hometeamname varchar(100),
    hometeamscore integer,
    venueid integer not null,
    venuename varchar(100),
    scheduledInnings integer not null
);

create table if not exists linescore (
    gamepk integer REFERENCES game not null,
    inning INTEGER not null,
    half INTEGER not null,
    battingteamid INTEGER not null,
    runs INTEGER,
    hits INTEGER,
    errors INTEGER,
    leftonbase INTEGER,
    battingteam_score INTEGER not null,
    battingteam_score_diff INTEGER not null,

    primary key (gamepk, inning, half, battingteamid)
);

create table if not exists runner_play (
    gamepk integer references game not null,
    atbatindex integer not null,
    playindex integer not null,
    playid uuid,
    runnerid INTEGER not null, 
    runnerfullname varchar(50),
    startbase varchar(5),
    endbase varchar(5),
    reachedbase varchar(5),
    is_out BOOLEAN not null,
    eventtype VARCHAR(100),
    movementreason VARCHAR(100),
    is_risp BOOLEAN not null,
    is_firsttothird BOOLEAN not null,
    is_secondtohome BOOLEAN not null,

    primary key (gamepk, atbatindex, playindex, runnerid)
); 

