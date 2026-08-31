
-- 3. Para cada década, mostre não só o time campeão de vitórias, mas o 2º e 3º colocados também (ranking com empates tratados corretamente).

show databases;
use lahmansbaseballdb;


select *
from teams
limit 5;

with decade as 
	(
	select
		yearID,
		teamID,
		W,
		L,
		(yearID div 10)*10 as decade
	from teams
    ),
ranked as
	(
	select
		yearID,
		teamID,
		W,
		L,
		decade,
		dense_rank() over (partition by decade order by W desc, L) as w_rank

	from decade
	)

select
	yearID,
    teamID,
    W,
    L,
    decade as Decada,
    w_rank as 'Rank'
from ranked
where w_rank between 1 and 3