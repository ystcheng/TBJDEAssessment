-- definition of come back wins: trails in score at any point of the game and wins.
with score_max_deficit as (
    -- find the biggest score difference at any point of the game for each team during each game. 
    -- specifically the smallest number in the negatives
    select gamepk, battingteamid, min(battingteam_score_diff) as highest_deficit
    from linescore
    group by gamepk, battingteamid
    -- only consider the team of the game that were behind at some point.
    having min(battingteam_score_diff) < 0 
),
winning_teams as (
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
)
select winning_teams.*, score_max_deficit.highest_deficit
from score_max_deficit
inner join winning_teams 
on winning_teams.gamepk = score_max_deficit.gamepk and winning_teams.teamid = score_max_deficit.battingteamid
order by score_max_deficit.highest_deficit
limit 1;
