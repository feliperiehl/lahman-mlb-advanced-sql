-- 5. Calcule, para cada franquia, o percentual de temporadas "acima da média da liga" em relação ao total de temporadas que ela jogou.

show databases;
use lahmansbaseballdb;

with avg_w as
	(
	select
		yearID,
		round(avg(W), 2) as avg_W
	from teams
	group by yearID
	)
,
count_season as
	(
	select
		franchID,
		count(*) as seasons
	from teams
	group by franchID
	)
,
join_year as
	(
	select
		t1.franchID as franchise,
		t1.yearID Year,
		t1.W as wins,
		t2.avg_W as AverageW
	from teams as t1
	inner join avg_w as t2
	on t1.yearID = t2.yearID
    )
,
flagged as
	(
	select
		franchise,
		Year,
		wins,
		AverageW,
		case when wins > AverageW then 1 else 0 end as Better_avg
	from join_year
    )
,
grouped as
	(
	select
		t1.franchise as Franchise,
		sum(Better_avg) as Qtt_Better,
		t2.seasons as Seasons
	from flagged as t1
	inner join count_season as t2
	on Franchise = t2.franchID
	group by Franchise
	)

select
	Franchise,
    Qtt_Better,
    Seasons,
    round((Qtt_Better / Seasons), 2) as percentage
from grouped
order by percentage desc
    
    


