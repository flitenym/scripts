select 
	* 
from sys.dm_db_missing_index_group_stats gs
inner join sys.dm_db_missing_index_groups g on g.index_group_handle = gs.group_handle
inner join sys.dm_db_missing_index_details d on d.index_handle = g.index_handle
order by avg_total_user_cost desc