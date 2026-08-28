show databases;
use lahmansbaseballdb;

-- 1. Quais franquias tiveram pelo menos uma temporada com mais de 100 vitórias entre 1990 e 2020?

with filtered_w as
	(
		select 
			franchID,
			yearID,
			W,
			case when W > 100 then 1 end as more_100_W
		from teams
        where yearID between 1990 and 2020
	)

select
	franchID,
    sum(more_100_W) as count_100
from filtered_w
group by franchID
having count_100 >= 1