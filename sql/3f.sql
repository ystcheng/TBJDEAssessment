-- definition of aggressive player
-- has the most attempted base stealing + attempted extra bases taken

with attempted_base_stealing as (
    select gamepk, atbatindex, playindex, runnerid, runnerfullname 
    from runner_play
    where 
        (movementreason like '%stolen_base%') or 
        (movementreason like '%stealing%')
), attempted_extra_bases_taken as (
    select gamepk, atbatindex, playindex, runnerid, runnerfullname 
    from runner_play
    where 
        ((eventtype = 'single' and 
        (
            is_firsttothird or
            is_secondtohome or
            (startbase = '1B' and endbase = 'HM') 
        )
        ) or (
            eventtype = 'double' and (
                (startbase = '1B' and endbase = 'HM')
            )
        ))
)
select runnerid, runnerfullname, count(*) as attempts 
from (
    select * from attempted_base_stealing 
    union
    select * from attempted_extra_bases_taken
) as result 
group by (runnerid, runnerfullname)
order by attempts desc