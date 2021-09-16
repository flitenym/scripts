--DECLARE @Temptable TABLE (AVGCPUTime int, SQL_Text nvarchar(max))

--INSERT INTO @Temptable (AVGCPUTime, SQL_Text)
SELECT TOP 50 
	total_worker_time/execution_count/1000 AS [AvgCPUTime]
	, SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
	((CASE qs.statement_end_offset 
		WHEN -1 THEN DATALENGTH(st.text) 
		ELSE qs.statement_end_offset 
	END - qs.statement_start_offset)/2) + 1) AS SQL_TEXT
FROM sys.dm_exec_query_stats AS qs 
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st 
where 1=1 
	and st.text is not null 
	and Last_execution_time > (getdate()-0.3) --разница с временем выполнения 7 часов
	--and st.[text] not like '%Emailbody%'
	and st.[text] like '%INSERT%'
ORDER BY Last_execution_time DESC;