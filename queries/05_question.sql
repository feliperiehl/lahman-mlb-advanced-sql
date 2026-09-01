-- 4. Quais jogadores apareceram como All-Star em anos consecutivos (pelo menos 3 anos seguidos sem interrupção)?

show databases;
use lahmansbaseballdb;

with selected as
	(
		select
			playerID,
			yearID,
			teamID,
			lag(YearID) over(partition by playerID order by yearID) as last_year
		from allstarfull
	)
,
next as
	(
	select
		playerID,
		yearID,
		teamID,
		last_year,
		sum(case when last_year is null or yearID != last_year + 1 then 1 else 0 end)
        over (partition by playerID order by yearID) as flag1
	from selected
	)
,
seq_length as (
    select
        playerID,
        flag1,
        teamID,
        min(yearID) as start_year,
        max(yearID) as end_year,
        count(*) as consecutive_years
    from next
    group by playerID, flag1, teamID
)
select
    playerID,
    start_year as 'Início',
    end_year as 'Fim',
    consecutive_years as 'Anos Consecutivos',
    teamID
from seq_length
where consecutive_years >= 3
order by playerID, start_year;
