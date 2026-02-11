with score_max_deficit as (
    select gamepk, battingteamid, min(battingteam_score_diff) as highest_deficit
    from linescore
    group by gamepk, battingteamid
    having min(battingteam_score_diff) < 0 
), score_max_deficit_game as (
    select gamepk, battingteamid, highest_deficit
    from (select 
        *,
        dense_rank() over (partition by gamepk order by highest_deficit asc) as rank 
        from score_max_deficit
    ) as x 
    where rank = 1
)
select score_max_deficit_game.*
from score_max_deficit_game
inner join game 
on game.gamepk = score_max_deficit_game.gamepk
where 
    case when game.awayteamscore > game.hometeamscore then game.awayteamscore = score_max_deficit_game.battingteamid
    else game.hometeamid = score_max_deficit_game.battingteamid
    end
order by score_max_deficit_game.highest_deficit
limit 1