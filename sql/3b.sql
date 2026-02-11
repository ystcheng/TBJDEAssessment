-- 3 b) --
with regular as (select gamepk from game where gametype = 'R')
select runnerid, runnerfullname, count(*) as stolen
from runner_play
natural join regular
where movementreason like '%stolen_base%'
and movementreason = concat('r_', eventtype) -- sanity check
group by runnerid, runnerfullname
having count(*) >= 35
order by stolen desc
