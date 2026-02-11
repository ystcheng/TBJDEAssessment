-- 3 a) --
with winning_teams as (
    (
        select
            gamepk,
            awayteamid as teamid,
            awayteamname as teamname
        from game
        where
            awayteamscore > hometeamscore
    )
    union all
    (
        select
            gamepk,
            hometeamid as teamid,
            hometeamname as teamname
        from game
        where
            hometeamscore > awayteamscore
    )
), trailing_team as (
    select distinct gamepk, battingteamid 
    from linescore
    where battingteam_score_diff < 0
)
select winning_teams.teamid, winning_teams.teamname, count(distinct winning_teams.gamepk) as comebackwins
from winning_teams 
inner join trailing_team
on winning_teams.gamepk = trailing_team.gamepk and winning_teams.teamid = trailing_team.battingteamid
group by winning_teams.teamid, winning_teams.teamname
order by comebackwins desc
limit 5;