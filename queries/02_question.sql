show databases;
use lahmansbaseballdb;

-- 1. Para cada franquia, calcule a variação de vitórias de uma temporada para a seguinte (ano atual vs ano anterior). Quais franquias tiveram a maior "queda" de um ano para o outro?
-- 1. For each franchise

with last_season as
	(
	select 
		yearID,
		franchID,
		W,
		lag(W) over (partition by franchID order by yearID) as last_season
	from teams
	order by franchID, yearID
	)
,

first_season as
	(
	select
		yearID,
        franchID,
        W,
        last_season,
        case when last_season != 0 then 1 end as first,
        round((W/nullif(last_season, 0)-1)*100, 2) as win_index
	from last_season
    )
,
ranked as
	(
	select 
		yearID,
		franchID,
        W,
        last_season,
		first,
		win_index,
		row_number() over(partition by franchID order by win_index asc) as indice
	from first_season
	where first = 1
	)

select *
from ranked
where indice = 1;
