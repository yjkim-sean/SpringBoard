<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<html>
<head>
<title>Home</title>
</head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.slim.js">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js">
<link rel="stylesheet" href="resources/css/login.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<a href="/board/list">게시판</a>
<br />
<script type="text/javascript">
	$(document).ready(function(){
		
		$("#logoutBtn").on("click", function(){
			location.href="member/logout";
		})
		
		$("#registerBtn").on("click", function(){
			location.href="member/register";
		})
		
		$("#memberUpdateBtn").on("click", function(){
			location.href="member/memberUpdateView";
		})
		
		$("#memberDeleteBtn").on("click", function(){
			location.href="member/memberDeleteView";
		})
		
	})
</script>
<body>

	<div class="container-fluid">
		<div class="row no-gutter">
			<div class="d-none d-md-flex col-md-4 col-lg-6 bg-image"></div>
			<div class="col-md-8 col-lg-6">
				<div class="login d-flex align-items-center py-5">
					<div class="container">
						<div class="row">
							<div class="col-md-9 col-lg-8 mx-auto">
								<h3 class="login-heading mb-4">Welcome!</h3>
								<form name='homeForm' method="post" action="/member/login">
									<c:if test="${member == null}">
										<div class="form-label-group">
											<input type="text" id="userId" name="userId" class="form-control" placeholder="Id" required autofocus> 
											<label for="userId">Id</label>
										</div>

										<div class="form-label-group">
											<input type="password" id="userPass" name="userPass" class="form-control" placeholder="Password" required> 
											<label for="userPass">Password</label>
										</div>
										
										<!--  
										<div class="custom-control custom-checkbox mb-3">
											<input type="checkbox" class="custom-control-input" id="customCheck1"> 
											<label class="custom-control-label" for="customCheck1">Remember password</label>
										</div>
										-->
											
										<c:if test="${msg == false}">
											<p style="color: red;">로그인 실패! 아이디와 비밀번호 확인해주세요.</p>
										</c:if>

										<button class="btn btn-lg btn-primary btn-block btn-login text-uppercase font-weight-bold mb-2" 
														 type="submit">Sign in</button>
										<button class="btn btn-lg btn-primary btn-block btn-login text-uppercase font-weight-bold mb-2"
														id="registerBtn" type="button">Register</button>

										<!--
										<div class="text-center">
											<a class="small" href="#">Forgot password?</a>
										</div>
										-->

									</c:if>
									<c:if test="${member != null }">
										<div>
											<h5 class="login-heading mb-4">${member.userName}님환영 합니다.</h5>
											<button id="memberUpdateBtn" type="button">회원정보수정</button>
											<button id="logoutBtn" type="button">로그아웃</button>
											<button id="memberDeleteBtn" type="button">회원 탈퇴</button>
										</div>
									</c:if>

								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>