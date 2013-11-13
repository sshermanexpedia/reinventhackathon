<script>
function goBack()
  {
  window.history.back()
  }
</script>
<link rel="stylesheet" type="text/css" href="/donorschoose/css/pivot.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" type="text/javascript"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript"></script>
<script type="text/javascript" src="/donorschoose/js/pivot.js"></script>
<script>
var myList = ${it.resultsJSON}
// Builds the HTML Table out of myList json data from Ivy restful service.
 function buildHtmlTable() {
     var columns = addAllColumnHeaders(myList);
 
     for (var i = 0 ; i < myList.length ; i++) {
         var row$ = $('<tr/>');
         for (var colIndex = 0 ; colIndex < columns.length ; colIndex++) {
             var cellValue = myList[i][columns[colIndex]];
 
             if (cellValue == null) { cellValue = ""; }
 
             row$.append($('<td/>').html(cellValue));
         }
         $("#excelDataTable").append(row$);
     }
 }
 
 // Adds a header row to the table and returns the set of columns.
 // Need to do union of keys from all records as some records may not contain
 // all records
 function addAllColumnHeaders(myList)
 {
     var columnSet = [];
     var headerTr$ = $('<tr/>');
 
     for (var i = 0 ; i < myList.length ; i++) {
         var rowHash = myList[i];
         for (var key in rowHash) {
             if ($.inArray(key, columnSet) == -1){
                 columnSet.push(key);
                 headerTr$.append($('<th/>').html(key));
             }
         }
     }
     $("#excelDataTable").append(headerTr$);
 
     return columnSet;
 }
 </script>
<body onLoad="buildHtmlTable()">
<button onclick="goBack()">Go Back</button>
<hr>
<table id="excelDataTable" border="1">
 </table>
<hr>
<script type="text/javascript">
            $(function(){
                        $("#output").pivotUI(
        ${it.resultsJSON}
    );
             });
        </script>

        <div id="output" style="margin: 10px;"></div>

</body>

