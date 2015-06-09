Parse.initialize("fonWQnx1RDOHSy5emNfTb76JOHZtwe37lOJzRnnD","C93Pwv3bwZswToCw4ARTx20hp7ZYLnbNfVcFnQyp");

function showDialog(id){
	var dialog = $(id).data('dialog');
    dialog.open();
}
$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})
$(document).on('click','.dialog-close-button',function(){
	$('#personPage').hide();
});