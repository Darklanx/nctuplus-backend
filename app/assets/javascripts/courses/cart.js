/*
 *
 * Copyright (C) 2015 NCTU+
 *
 * For courses shopping cart
 *
 * Modified at 2015/6/17
 */

function add_to_cart($this_but, id,type){
	$.ajax({
		type: "GET",
		url : "/courses/add_to_cart",
		data : {
			cd_id:id,
			type:type
		},
		success : function(data){
			toastr[data.class](data.text);
		}
	});
	if (type == 'delete')
            $this_but.parent().parent().parent().remove();

}
function showCart(){
	$.get("/courses/show_cart",
		{
			view_type:"session",
			use_type:"delete",
			add_to_cart:"0"
		},
		function(data){
			showGlobalModal(1,"收藏課程",data,function(){$("#global-modal").find(".modal-body").html("");});
		}
	);
}
