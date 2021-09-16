SET NOCOUNT ON
DECLARE @name varchar(128),
        @substr nvarchar(4000),
        @column varchar(128)
SET @substr = '3F045306-D0A8-4007-932B-0023685CD490' --фрагмент строки, который будем искать
CREATE TABLE #rslt (
  table_name varchar(128),
  field_name varchar(128),
  value uniqueidentifier
)
DECLARE s CURSOR FOR
SELECT
  table_name AS table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
ORDER BY table_name
OPEN s
FETCH NEXT FROM s INTO @name
WHILE @@fetch_status = 0
BEGIN
  DECLARE c CURSOR FOR
  SELECT
    QUOTENAME(column_name) AS column_name
  FROM information_schema.columns
  WHERE data_type = 'uniqueidentifier'
  AND table_name = @name
  SET @name = QUOTENAME(@name)
  OPEN c
  FETCH NEXT FROM c INTO @column
  WHILE @@fetch_status = 0
  BEGIN
    PRINT 'Processing table - ' + @name + ', column - ' + @column
    EXEC ('insert into #rslt select ''' + @name + ''' as Table_name, ''' + @column + ''', ' + @column +
    ' from' + @name + ' where ' + @column + ' like ''' + @substr + '''')
    FETCH NEXT FROM c INTO @column
  END
  CLOSE c
  DEALLOCATE c
  FETCH NEXT FROM s INTO @name
END
SELECT
  table_name AS [Table Name],
  field_name AS [Field Name],
  COUNT(*) AS [Found Mathes]
FROM #rslt
GROUP BY table_name,
         field_name
ORDER BY table_name, field_name
--Если нужно, можем отобразить все найденные значения
--select * from #rslt order by table_name, field_name
DROP TABLE #rslt
CLOSE s
DEALLOCATE s