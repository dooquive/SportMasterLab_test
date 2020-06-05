select
    tt."Departament",
    tt."Employee",
    tt."Salary"
    
from
    (
        select
            dep."NAME" as "Departament",
            emp."NAME" as "Employee",
            emp."SALARY" as "Salary",
            DENSE_RANK() over (partition by dep."ID" order by emp."SALARY" desc) as "salary_rank"
        from
            "DEPARTAMENT" dep
            
        inner join
            "EMPLOYEE" emp
        
            on
                dep."ID" = emp."DEPARTAMENT_ID"
    ) tt

where
    "salary_rank" <= 3