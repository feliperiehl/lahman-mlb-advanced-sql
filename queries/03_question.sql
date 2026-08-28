show databases;
use lahmansbaseballdb;

-- 2. Calcule o total de vitórias acumuladas (running total) de cada franquia ao longo do tempo, ano após ano.

select
	yearID,
    franchID,
    sum(W) over(partition by franchID order by yearID) AS RUNNING_TOTAL
from teams
order by 2 desc