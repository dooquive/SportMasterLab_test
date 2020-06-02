select
    final_cte."Day",
    round(final_cte."CANCELLED_TRIPS_COUNT"/NULLIF(final_cte."ALL_TRIPS_PER_DAY", 0), 2) as "Cancellation_Rate"
from
    (
        select
            trips_summary.REQUEST_AT as "Day",
            trips_summary."ALL_TRIPS_PER_DAY",
            case
                when trips."CANCELLED_TRIPS_COUNT" is null then 0
                else trips."CANCELLED_TRIPS_COUNT"
            end as "CANCELLED_TRIPS_COUNT"
        from
            (
                select
                    tr_sum."REQUEST_AT",
                    count(*) as "ALL_TRIPS_PER_DAY"
                from
                    "TRIPS" tr_sum
                group by
                    tr_sum."REQUEST_AT"
            ) trips_summary
            
        left join
        
            (
                select 
                    tr."REQUEST_AT",
                    count(*) as "CANCELLED_TRIPS_COUNT"
                
                from
                    "TRIPS" tr
                    
                left join
                    "USERS" usr_clients
                    on
                        tr."CLIENT_ID" = usr_clients."USER_ID"
                        
                left join
                    "USERS" usr_drivers
                    on
                        tr."DRIVER_ID" = usr_drivers."USER_ID"
                
                where
                    usr_clients."BANNED" = 'No' and
                    usr_drivers."BANNED" = 'No' and
                    tr."REQUEST_AT" >= to_date('2013-10-01','YYYY-MM-DD') and
                    tr."REQUEST_AT" <= to_date('2013-10-03','YYYY-MM-DD') and
                    tr."STATUS" != 'completed'
                    
                group by
                    tr."REQUEST_AT"
            ) trips
            
            on
                trips_summary."REQUEST_AT" = trips."REQUEST_AT"
    ) final_cte
    
order by
    final_cte."Day"
