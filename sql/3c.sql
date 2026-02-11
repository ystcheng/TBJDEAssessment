select runnerid, runnerfullname, count(distinct playid) as count
from runner_play
where 
    not is_out AND
    ((eventtype = 'single' and 
    (
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
limit 10