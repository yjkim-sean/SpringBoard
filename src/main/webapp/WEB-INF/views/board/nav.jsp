<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style type="text/css">
	li {list-style: none; display:inline; padding: 10px}
	#navli {padding-top: 10px; padding-bottom: 30px; float: left;}
</style>
<ul>
	<li id="navli" style="padding-right: 15px"><a href="/">메인으로</a></li>
	<li id="navli" style="padding-right: 5px">
		<c:if test="${member != null}">
			${member.userName}님
		</c:if>
	</li>
	
	<li id="navli">
		<c:if test="${member != null}"><a href="/member/logout">로그아웃</a></c:if>
		<c:if test="${member == null}"><a href="/">로그인</a></c:if>
	</li>
	<li id="navli" style="float: right; padding-right: 40px"><a href="/board/writeView">글 작성</a></li>
</ul>