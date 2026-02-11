-- 3 a) --
with game_winning_team as 
(
    select gamepk, 
        case when awayteamscore > hometeamscore then awayteamid
        else hometeamid
        end as winningteamid
    from game 
), trailing_team as (
    select distinct gamepk, battingteamid 
    from linescore
    where battingteam_score_diff < 0
)
select 
game_winning_team.winningteamid,
    count(distinct game_winning_team.gamepk) as comebackwins
from trailing_team
inner join game_winning_team
on trailing_team.gamepk = game_winning_team.gamepk and trailing_team.battingteamid = game_winning_team.winningteamid
group by game_winning_team.winningteamid
order by comebackwins desc 
limit 5