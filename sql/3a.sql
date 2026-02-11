with regular_games as (
    -- query for getting regular games
    select * from game where gametype = 'R'
),
winning_teams as (
    -- concat the two results together
    (
        -- select the games where the away team has won 
        select
            gamepk,
            awayteamid as teamid,
            awayteamname as teamname
        from regular_games
        where
            awayteamscore > hometeamscore
    )
    union all
    (
        -- select the games where the home team has won
        select
            gamepk,
            hometeamid as teamid,
            hometeamname as teamname
        from regular_games
        where
            hometeamscore > awayteamscore
    )
)
select
    teamid,
    teamname,
    count(*) as wins
from winning_teams
group by teamid, teamname
order by wins desc
limit 5