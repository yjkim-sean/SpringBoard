<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
	<head>
		<title>회원가입</title>
	</head>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.slim.min.js">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
	<link rel="stylesheet" href="../resources/css/register.css">
	 	
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function(){
			
			$("#submit").on("click", function(){
				if($("#userPass").val()==""){
					alert("비밀번호를 입력해주세요.");
					$("#userPass").focus();
					return false;
				}
				if($("#userName").val()==""){
					alert("성명을 입력해주세요.");
					$("#userName").focus();
					return false;
				}
				
				$.ajax({
					url : "/member/passChk",
					type : "POST",
					dateType : "json",
					data : $("#updateForm").serializeArray(),
					success: function(data){
						
						if(data==true){
							if(confirm("회원수정하시겠습니까?")){
								$("#updateForm").submit();
							}
							
						}else{
							alert("패스워드가 틀렸습니다.");
							return;
						}
					}
				})
			});
			
		})
	</script>
	
	<body>
		<div class="container">
    <div class="row">
      <div class="col-lg-10 col-xl-9 mx-auto">
        <div class="card card-signin flex-row my-5">
          <div class="card-img-left d-none d-md-flex">
           <!-- Background image for card set in CSS! -->
          </div>
          <div class="card-body">
            <h5 class="card-title text-center">Settings</h5>
							<form class="form-signin" id="updateForm" action="/member/memberUpdate" method="post">
							
								<div class="form-label-group">
                	<input type="text" id="userId" name="userId" value="${member.userId}" readonly="readonly" class="form-control" placeholder="userId" required autofocus>
                	<label for="userId">Id</label>
             		</div>
								
								<div class="form-label-group">
                	<input type="password" id="userPass" name="userPass" class="form-control" placeholder="userPass" required>
                	<label for="userPass">Password</label>
              	</div>
              
	              <div class="form-label-group">
	                <input type="text" id="userName" name="userName" value="${member.userName}" class="form-control" placeholder="userName" required>
	                <label for="userName">Name</label>
	              </div>
	              
	              <div>
									<button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Edit</button>
									<a class="d-block text-center mt-2 small" href="/">cancel</a>
								</div>
								
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  </div>
		
	</body>
	
</html>