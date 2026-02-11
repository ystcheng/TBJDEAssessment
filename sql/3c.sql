-- split into these conditions:
-- 1. single
-- 1.1 first to third
-- 1.2 second to home
-- 1.3 first to home
-- 2. double
-- 2.1 first to home
select runnerid, runnerfullname, count(*) as count
from runner_play
where 
    -- extra bases taken -> must be safe
    not is_out AND
    ((
        eventtype = 'single' and (
        is_firsttothird or
        is_secondtohome or
        (startbase = '1B' and reachedbase = 'HM') 
    )
    ) or (
        eventtype = 'double' and (
            (startbase = '1B' and reachedbase = 'HM')
        )
    ))
group by runnerid, runnerfullname 
order by count desc
limit 10;