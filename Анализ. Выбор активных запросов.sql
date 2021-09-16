--select cmd,* from sys.sysprocesses
--where blocked > 0

--exec sp_who2

SELECT
	SDER.session_id
	,SDER.command
	,SDER.status
	,SDER.total_elapsed_time
	,SDER.cpu_time
	,SDER.granted_query_memory
	,DEST.text
FROM sys.[dm_exec_requests] SDER 
CROSS APPLY sys.[dm_exec_sql_text](SDER.[sql_handle]) DEST
where 
	SDER.cpu_time<>0
ORDER BY SDER.[session_id], SDER.[request_id]