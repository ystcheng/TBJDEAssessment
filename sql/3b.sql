-- 3 b) --
-- Note:
-- The result will be underestimated due to potential loss of information when summarizing runner's play.
-- The event summary always naively chooses the last movement event type and movement (for simplicity) of the runner's play
-- This will cause in scenarios where the runner steals successfully + extra movement they won't be able to be counted.
with regular_season as (
    select gamepk from game where gametype = 'R'
)
select
    runnerid,
    runnerfullname,
    count(*) as stolen
from runner_play 
inner join regular_season using (gamepk)
where
    -- movement reason would always reflect the runner's actual movement reason 
    movementreason like '%stolen_base%'
group by
    runnerid,
    runnerfullname
having
    count(*) >= 35
order by
    stolen desc
;


