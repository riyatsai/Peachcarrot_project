Parse.initialize("fonWQnx1RDOHSy5emNfTb76JOHZtwe37lOJzRnnD","C93Pwv3bwZswToCw4ARTx20hp7ZYLnbNfVcFnQyp");
//loged?
$(document).ready(function(){
  var current=Parse.User.current();
  if(current){
   	$('.logged').show();
    $('.unlogged').hide();
    $('#personPage').html("<div class=\"userPic\"><input id=\"imgFile\" type=\"file\"></div><div class=\"profile\"><span class=\"username\">"+current.get("username")+"學習進度</span></div></br></br><p style=\"float:left;\">(點選上方上傳大頭貼！)</p></br></br><div class=\"progressDiv\"><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"><span class=\"modalProgressTitle\">斜紋</span></span><div id=\"progress1\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"><span class=\"modalProgressTitle\">V形</span></span><div id=\"progress2\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"><span class=\"modalProgressTitle\">心形</span></span><div id=\"progress3\" class=\"progress large\" data-value=\"0\" data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"><span class=\"modalProgressTitle\">菱形</span></span><div id=\"progress4\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"><span class=\"modalProgressTitle\">Zigzag</span></span><div id=\"progress5\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></div><span class=\"dialog-close-button\"></span></div>");
	$('.userPic').css({'background':'url('+current.get('img').url()+')','background-size':'130px 130px'});
  }
  else{
    $('.logged').hide();
    $('.unlogged').show();
	if(window.location.href.match('course.html')){
		window.location = 'login.html';	
	}
  }
  
  var anchor = (window.location.href.match(/#[a-zA-Z0-9]*/g)==null?null:window.location.href.match(/#[a-zA-Z0-9]*/g)[0].substr(1));
  if(anchor!=null){
    var aTag = $("a[name='"+ anchor +"']");
    $('html,body').animate({scrollTop: aTag.offset().top},'slow');
  }
  
});
//logout
$(document).on('click','.logged',function(e){
    e.preventDefault();
    Parse.User.logOut();
    window.location="peachparrot.html";
});
//to course page
function toCourse(index){
  window.location = 'course.html#scroll'+index;
}
//header tooltip
$(function () {
    $('[data-toggle="tooltip"]').tooltip()
})
//scroll 
$(function(){
  $.scrollIt();
  $('.carousel').carousel();
});

$('#myTab a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})
//modal
function showDialog(id){
	var current=Parse.User.current();
	if(current){
		getProgress();	
    	var dialog = $(id).data('dialog');
    	dialog.open();
	}	
	else{
		alert("請先登入喔！");
		window.location = 'login.html';		
	}
}

$(document).on('click','.dialog-close-button',function(){
	$('#personPage').data('dialog').close();
});
//update progress
function CourseUpdate(courseId){
    event.preventDefault();
	var step = [];
	var index = 0;
	$("#Course"+courseId+" input[name='step[]']").each(function(index){
			step[index++] = ($(this).prop("checked")?1:0);
	    });
	step[step.length] = parseInt(($("#Course"+courseId+" .slider-hint").text()==null?0:$("#Course"+courseId+" .slider-hint").text()));
    console.log(step);	
	var Course = Parse.Object.extend('CourseProgress');
	var course = new Parse.Query(Course);
	course.equalTo('CourseId',courseId);
	course.equalTo('UserId',Parse.User.current());	
	course.find({
		success:function(obj){	
			if($.isEmptyObject(obj)){
				var newCourse = new Course();
				newCourse.set('Progress',step);
				newCourse.set('CourseId',courseId);
				newCourse.set('UserId',Parse.User.current());
				newCourse.save(null,{
					sucesss:function(obj2){
						console.log('new course');
					},
					error:function(obj2,err2){
						console.log('new course fail');
				}
				
				});
			}
		    else{
				obj[0].set('Progress',step);
				obj[0].save(null,{
					sucesss:function(obj2){
						console.log('update course');
					},
					error:function(obj2,err2){
						console.log('update course fail');
					}
				});
		    }
			var checked = 0;
			var percent=0;
			for(var i=0;i<step.length-1;i++){
				if(step[i]>0){checked++;}
			}
			percent = checked/step.length+(step[step.length-1]/(step.length*100));
			console.log(percent);
			showDialog('#personPage');	
			$('#progress'+courseId+" .bar").width((percent*100)+"%");
		},
		error:function(obj,err){
			alert('find course fail');
		}
	});		
	
}

//get progress
function getProgress(){
	var Course = Parse.Object.extend('CourseProgress');
	var course = new Parse.Query(Course);
	//course.equalTo('Progress',step);
	course.equalTo('UserId',Parse.User.current());	
	course.find({
		success:function(obj){
			for (var j = 0 ; j < obj.length ; j++){ 
				course = obj[j] ; 
				courseId=course.get("CourseId");
				step=course.get("Progress");			
				var checked = 0;
				var percent=0;
				for(var i=0;i<step.length-1;i++){
					if(step[i]>0){checked++;}
				}
				percent = checked/step.length+(step[step.length-1]/(step.length*100));
				$('#progress'+courseId+" .bar").width((percent*100)+"%");			
			}
								
		},
		error:function(obj,err){
			alert('find course fail');
		}
	});
}


//login
$(document).on('submit','#logInForm',function(e){
  console.log('logIn submit');
  e.preventDefault();
  var usr=$("#username").val();
  var password=$("#password").val();

  Parse.User.logIn(usr,password,{
  success:function(data){
	  var current=Parse.User.current();
	  current.set("signature",1);
	  current.save(null,{
		  success:function(data){
			  window.location="peachparrot.html";
		  },
		  error:function(data,error){
			  alert("sorry");
		  }
	  });
  },
  error:function(data,error){
	  alert("fail");
  }
  });
});
//signup 
$(document).on('submit','#signUpForm',function(e){	
  e.preventDefault();
  var usr=$('#username').val();
  var mail=$('#email').val();
  var pwd=$("#password").val();
  var role=$("input:checked").val();

  var user=new Parse.User();
  user.set("username",usr);
  user.set("email",mail);
  user.set("password",pwd);
  user.set("signature",0);
  
  user.signUp(null,{
	  success:function(data){
		  alert("註冊成功");
		  
		  window.location="peachparrot.html";
	  },
	  error:function(data,error){
		  console.log(error);
	  	  alert("註冊失敗");
	  }
  });
  
});  
$(document).on('change','#imgFile',function(){
    var user = Parse.User.current();
    var file = $("#imgFile")[0].files[0];
	var parseImg = new Parse.File(user.get('username'), file);
    user.set("img",parseImg);
	
	user.save(null,{
		success:function(data){
			$('.userPic').css({'background':'url('+data.get('img').url()+')','background-size':'130px 130px'});
		},
		error:function(data,error){
			console.log(error);
			alert('img upload fail');
		}
	});
});