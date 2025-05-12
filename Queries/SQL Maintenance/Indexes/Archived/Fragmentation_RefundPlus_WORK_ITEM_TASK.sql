--To Find out fragmentation level of a given database and table
USE PRL_ALLIEDSYS_PROD

DECLARE @db_id SMALLINT;
DECLARE @object_id INT;
DECLARE @mode VARCHAR(10)--modes are (LIMITED/SAMPLED/DETAILED)

SET @mode ='LIMITED';
SET @db_id = Db_id( (select DB_NAME()));
SET @object_id = Object_id(N'dbo.WORK_ITEM_TASK')

/*

mode specifies the scan level that is used to obtain statistics. Valid inputs are DEFAULT, NULL, LIMITED, SAMPLED, or DETAILED. The default (NULL) is LIMITED.

LIMITED - It is the fastest mode and scans the smallest number of pages. For an index, only the parent-level pages of the B-tree (that is, the pages above the leaf level) are scanned. In SQL Server 2008, only the associated PFS and IAM pages of a heap are examined; the data pages of the heap are not scanned. In SQL Server 2005, all pages of a heap are scanned in LIMITED mode.

SAMPLED - It returns statistics based on a 1 percent sample of all the pages in the index or heap. If the index or heap has fewer than 10,000 pages, DETAILED mode is used instead of SAMPLED.

DETAILED - It scans all pages and returns all statistics.
*/


IF @object_id IS NULL
  BEGIN
      PRINT N'Invalid object';
  END
ELSE
  BEGIN
      SELECT Object_name(IPS.object_id) AS [TableName],
             SI.name                    AS [IndexName],
             IPS.Index_type_desc,
             IPS.avg_fragmentation_in_percent,
             IPS.avg_fragment_size_in_pages,
             IPS.avg_page_space_used_in_percent,
             IPS.record_count,
             IPS.ghost_record_count,
             IPS.fragment_count,
             IPS.avg_fragment_size_in_pages,
             CASE
               WHEN IPS.Index_type_desc = 'NONCLUSTERED INDEX'
                    AND IPS.avg_fragmentation_in_percent >= '30.' THEN Concat('ALTER INDEX [', SI.name, '] ON [',Object_name(IPS.object_id), '] REORGANIZE')
				WHEN IPS.Index_type_desc = 'HEAP' THEN Concat('CANNOT REORGANIZE HEAPS on ', Object_name(IPS.object_id),'!!!')
				WHEN IPS.Index_type_desc = 'CLUSTERED INDEX' AND IPS.avg_fragmentation_in_percent >= '30.' THEN Concat('DO WE REALLY NEED TO REORG A CLUSTERED INDEX ON ', Object_name(IPS.object_id),'---' ,'ALTER INDEX [', SI.name, '] ON [',Object_name(IPS.object_id), '] REORGANIZE')
               ELSE Concat('[', si.NAME, '] DOES NOT CURRENTLY NEED TO BE REORGANIZED!!!')
             END
      FROM   sys.Dm_db_index_physical_stats(@db_id, @object_id, NULL, NULL, @mode) AS IPS
             JOIN sys.tables ST WITH (nolock)
               ON IPS.object_id = ST.object_id
             JOIN sys.indexes SI WITH (nolock)
               ON IPS.object_id = SI.object_id
                  AND IPS.index_id = SI.index_id
      WHERE  ST.is_ms_shipped = 0
      ORDER  BY 1,
                5
  END

GO 


