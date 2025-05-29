use unitrac


select * from work_item
where id in (46850218, 46850187)


select * from process_log
where id in (61099669,
61100922)


select * from process_log_item
where process_log_id in (61099669,
61100922) and relate_type_cd in ('Allied.UniTrac.Notice','Allied.UniTrac.ForcePlacedCertificate')
order by relate_type_cd, status_cd ASC


select * from output_batch
where id in (1934772,1934786,
1934787,
1934769,
1934770,
1934771,
1934773,
1934788)


select * from notice
where id in (select relate_id from process_log_item
where process_log_id in (61099669,
61100922) and relate_type_cd in ('Allied.UniTrac.Notice'))

select * from force_placed_Certificate
where id in (select relate_id from process_log_item
where process_log_id in (61099669,
61100922) and relate_type_cd in ('Allied.UniTrac.ForcePlacedCertificate'))




select * from process_definition
where id in (51,83)


select * from PROCESS_LOG
where process_definition_id in (83,6,
51) and update_dt >= '2018-06-28'
order by update_dt DESC




select pd.NAME_TX, PL.* from process_log pl
join process_definition pd on pd.id = pl.process_definition_id
where pl.update_dt >= '2018-06-28 11:00' and  pl.update_dt <= '2018-06-28 13:00'
order by pl.update_dt DESC



select * from process_log_item
where process_log_id in (61099669,
61100922)
and relate_type_cd  in --('Allied.UniTrac.Notice','Allied.UniTrac.ForcePlacedCertificate')
('Allied.UniTrac.ReportHistory')


select * from report_history
where id in (select relate_id from process_log_item
where process_log_id in (61099669,
61100922)
and relate_type_cd  in --('Allied.UniTrac.Notice','Allied.UniTrac.ForcePlacedCertificate')
('Allied.UniTrac.ReportHistory'))





select * from notice
where id in (select relate_id from process_log_item
where process_log_id in (61099669,
61100922) and relate_type_cd in ('Allied.UniTrac.Notice'))

select * from force_placed_Certificate
where id in (select relate_id from process_log_item
where process_log_id in (61099669,
61100922) and relate_type_cd in ('Allied.UniTrac.ForcePlacedCertificate'))
