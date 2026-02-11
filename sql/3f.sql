-- This query measures baserunner's "aggressiveness" by identifying the number of attempts in base stealing and extra bases taken.
-- The reason behind this definition is based on an assumption that being aggressive for base runners implies that they take risks outside of the expected play to advanced bases.
-- So, since both base stealing and extra base taken are metrics that satisfy this criteria, then the number of attempts of such events (regardless if they get caught or not)
-- can be used to dictate the amount of risk taking -> aggressiveness

-- For simplicity, this query weighes each scenario equally 

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
limit 5;