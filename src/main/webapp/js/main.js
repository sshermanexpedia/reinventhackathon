var rootURL = "donorschoose/webresources";

// Register listeners
$('#btnSQL').click(function() {
        search($('#sqlText').val());
        return false;
});

//Trigger search when pressing 'Return' on search key input field
$('#sqlText').keypress(function(e){
        if(e.which == 13) {
                sqlExecute($('#sqlText').val());
                e.preventDefault();
                return false;
    }
});

function sqlExecute(sqlQuery) {
    if (sqlQuery == '')
            getAll();
    else
            getBySQL(sqlQuery);
}

function getAll() {
    console.log('getAll');
    $.ajax({
            type: 'GET',
            url: rootURL + '/browse/',
            dataType: "json", // data type of response
            success: renderList
    });
}

function getBySQL(sqlQuery) {
    console.log('getBySQL: ' + sqlQuery);
    $.ajax({
            type: 'POST',
            url: rootURL + '/research/',
            data: sqlQuery,
            dataType: "json",
            success: renderList
    });
}

function renderList(data) {
    // JAX-RS serializes an empty list as null, and a 'collection of one' as an object (not an 'array of one')
    var list = data == null ? [] : (data instanceof Array ? data : [data]);

    $('#resultList li').remove();
    $.each(list, function(index, result) {
            $('#resultList').append('<li>'+result+'</li>');
    });
}
