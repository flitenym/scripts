DECLARE @startnum INT=1
DECLARE @endnum INT=10000

;WITH gen AS (
    SELECT @startnum AS num
    UNION ALL
    SELECT num+1 FROM gen WHERE num+1<=@endnum
)
SELECT
	NEWID() as ID
FROM gen
option (maxrecursion @endnum)