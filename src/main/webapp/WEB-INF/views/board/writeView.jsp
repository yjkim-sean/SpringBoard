<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<link rel="stylesheet" href="../resources/css/bootstrap.min.css">
<link rel="stylesheet" href="../resources/css/list.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>게시판</title>
</head>

<script type="text/javascript">
		$(document).ready(function(){
			var formObj = $("form[name='writeForm']");
			
			$(".cancel_btn").on("click", function(){
				event.preventDefault();
				location.href = "/board/list";
			})
			
			$(".write_btn").on("click", function(){
				if(fn_valiChk()){
					return false;
				}
				formObj.attr("action", "/board/write");
				formObj.attr("method", "post");
				formObj.submit();
			});

			fn_addFile();
		})
		
		function fn_valiChk(){
			var regForm = $("form[name='writeForm'] .chk").length;
			for(var i = 0; i<regForm; i++){
				if($(".chk").eq(i).val() == "" || $(".chk").eq(i).val() == null){
					alert($(".chk").eq(i).attr("title"));
					return true;
				}
			}
		}
		
		//파일 추가
		function fn_addFile(){
			var fileIndex = 1;
			//$("#fileIndex").append("<div><input type='file' style='float:left;' name='file_"+(fileIndex++)+"'>"+"<button type='button' style='float:right;' id='fileAddBtn'>"+"추가"+"</button></div>");
			$(".fileAdd_btn").on("click", function(){
				$("#fileIndex").append("<div><input type='file' style='float:left;' name='file_"+(fileIndex++)+"'>"+"</button>"+"<button type='button' style='float:right;' id='fileDelBtn'>"+"삭제"+"</button></div>");
			});
			$(document).on("click","#fileDelBtn", function(){
				$(this).parent().remove();
				
			});
		}
	</script>


<body>

	<div id="container">
		<header>
			<div id="list"><a href="/board/list"><h1>게시판</h1></a></div>
		</header>
		<hr />

		<div>
			<%@include file="nav.jsp" %>
		</div>
		<hr />

		<section id="container">
			<form name="writeForm" role="form" method="post" action="/board/write" enctype="multipart/form-data">
			<!-- enctype : 양식 데이터를 서버에 제출할 때 양식 데이터를 인코딩하는 방법을 지정 / 첨부파일 업로드 위해서-->
				<table>
					<tbody>
					<c:if test="${member.userId != null}">
								<tr>
									<td>
										<label for="title">제목</label><input type="text" id="title" name="title" class="chk" title="제목을 입력하세요."/>
									</td>
								</tr>	
								<tr>
									<td>
										<label for="content">내용</label><textarea id="content" name="content" class="chk" title="내용을 입력하세요."></textarea>
									</td>
								</tr>
								<tr>
									<td>
										<label for="writer">작성자</label><input type="text" id="writer" name="writer" class="chk" title="작성자를 입력하세요." readonly="readonly" value="${member.userId}" />
									</td>
								<tr>
								<tr>
									<td id="fileIndex">
									</td>
								<tr>
									<td>						
										<button class="write_btn" type="button">작성</button>	
										<button class="fileAdd_btn" type="button">파일추가</button>	
									</td>
								</tr>	
							</c:if>
						
					</tbody>
					
				</table>
			</form>
		</section>
		<hr />
	</div>
</body>
</html>