UPDATE WIDGET_TYPE
SET SCRIPT_OPTIONS_TXT =
'<script src="/FusionCharts/fusioncharts.js"></script>
<script type="text/javascript">
		 function drawChart_FUSION( p_Widget, p_DivID ) {

		 		 chartType		 = p_Widget.JSONData.chart.type;

		 		 var myChart = new FusionCharts(
		 		 		 {
		 		 		 id:		 		 p_DivID + ''chart'',
		 		 		 "type":		 		 chartType,
		 		 		 "renderAt":		 p_DivID,
		 		 		 "width":		 "100%",
		 		 		 "height":		 "100%",
		 		 		 "dataFormat":		 "json",
		 		 		 "dataSource":		 p_Widget.JSONData
		 		 		 }
		 		 );

		 		 myChart.render();
		 }
</script>'
WHERE PROVIDER_TYPE_CD = 'FUSION'