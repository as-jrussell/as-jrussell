

--SELECT state_desc, * FROM sys.databases

--Parameterization @ 0 means Simple and 1 means Forced
--SELECT name, is_parameterization_forced FROM sys.databases


SELECT name,  
CASE  is_parameterization_forced 
WHEN 1 THEN 'Yes'
ELSE 'No'
END AS is_parameterization_forced 
FROM sys.databases