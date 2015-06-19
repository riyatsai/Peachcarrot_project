Parse.initialize("fonWQnx1RDOHSy5emNfTb76JOHZtwe37lOJzRnnD","C93Pwv3bwZswToCw4ARTx20hp7ZYLnbNfVcFnQyp");
//loged?
$(document).ready(function(){
  var current=Parse.User.current();
  if(current){
   	$('.logged').show();
    $('.unlogged').hide();
    $('#personPage').html("<div class=\"userPic\"></div><div class=\"profile\"><span class=\"username\">Emma Watson</span></div><div class=\"progressDiv\"><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"></span><div id=\"progress1\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"></span><div id=\"progress2\" class=\"progress large\" data-value=\"0\" data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"></span><div id=\"progress3\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></br><span class=\"glyphicon glyphicon-star\" style=\"color:#FFEE99;display:inline-block;\"></span><div id=\"progress4\" class=\"progress large\" data-value=\"0\"  data-role=\"progressBar\"><div class=\"bar\" style=\"background-color:#ACDCCE;\"></div></div></div><span class=\"dialog-close-button\"></span></div>");
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
	var Course = Parse.Object.extend('CourseProgress');
	var course = new Parse.Query(Course);
	//course.equalTo('Progress',step);
	course.equalTo('UserId',Parse.User.current());	
	course.find({
		success:function(obj){
			for (var i = 0 ; i < obj.length ; i++){ 
				course = obj[i] ; 
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
	
	if(current){	
    	var dialog = $(id).data('dialog');
    	dialog.open();
	}	
	else{
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
	//course.equalTo('Progress',step);
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
			runModal(step,courseId);			
		},
		error:function(obj,err){
			alert('find course fail');
		}
	});
}
function runModal(step,courseId){
	var checked = 0;
	var percent=0;
	for(var i=0;i<step.length-1;i++){
		if(step[i]>0){checked++;}
	}
	percent = checked/step.length+(step[step.length-1]/(step.length*100));
	console.log(percent);
	
	var dialog = $('#personPage').data('dialog');
	dialog.open();

	$('#progress'+courseId+" .bar").width((percent*100)+"%");
}
//login
$(document).on('submit','#logInForm',function(e){
  console.log('logIn submit');
  e.preventDefault();
  var usr=$("#username").val();
  var password=$("#password").val();

  Parse.User.logIn(usr,password,{
  success:function(data){
	  alert("success");
	  var current=Parse.User.current();
	  current.set("signature",1);
	  current.save(null,{
		  success:function(data){
			  alert("update completely");
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
