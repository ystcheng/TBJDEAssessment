-- 3 a) --
with wins as (select gamepk, gamedate, officialdate, 
    case when awayteamscore > hometeamscore then awayteamname
    else hometeamname
    end as winningteam
from game 
where gametype = 'R'
)
select winningteam, count(*) as wins
from wins
group by winningteam
order by wins desc
limit 5
;
