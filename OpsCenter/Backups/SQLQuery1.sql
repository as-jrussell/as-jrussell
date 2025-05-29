use premacc3	


select *
from sys.tables 
where name not in ('Import_List', 'ImportParameters', 'ImportParametersHistory', 'Report_List', 'ReportParameters', 'ReportParametersHistory', 'Parameters', 'Big_Parameters', 'ScheduleParameter')