function showDialog(id){
	var dialog = $(id).data('dialog');
    dialog.open();
}
$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})