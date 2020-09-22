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

<body>
	<div id="container">
		<header>
			<div id="list"><a href="/board/list"><h1>게시판</h1></a></div>
		</header>
		<hr />

		<div>
			<%@include file="nav.jsp" %>
		</div>

		<div>
			<form role="form" method="get" action="/board/write">
      <table class="table table-bordered table-hover">
					<thead>
						<tr>
							<th width="10%">번호</th>
							<th width="50%">제목</th>
							<th width="10%">작성자</th>
							<th width="20%">작성일</th>
							<th width="10%">조회수</th>
						</tr>
					</thead>

        <tbody>
					<c:forEach items="${list}" var="list">
						<tr>
							<td><c:out value="${list.bno}" /></td>
							<td id="title">
								<a href="/board/readView?bno=${list.bno}&page=${scri.page}&perPageNum=${scri.perPageNum}&searchType=${scri.searchType}&keyword=${scri.keyword}">
								<c:out value="${list.title}" /></a>
								<c:if test="${list.hit >= 20}">
                  <span class="hit">hit!</span>
                </c:if>
							</td>
							<td><c:out value="${list.writer}" /></td>
							<td><fmt:formatDate value="${list.regdate}" pattern="yyyy-MM-dd" /></td>
							<td><c:out value="${list.hit}" /></td>
						</tr>
					</c:forEach>
				</tbody>
				</table>
				
			 <div class="search row">
			 	<div class="col-xs-2 col-sm-2">
			    <select name="searchType" class="form-control">
			      <option value="n"<c:out value="${scri.searchType == null ? 'selected' : ''}"/>>-----</option>
			      <option value="t"<c:out value="${scri.searchType eq 't' ? 'selected' : ''}"/>>제목</option>
			      <option value="c"<c:out value="${scri.searchType eq 'c' ? 'selected' : ''}"/>>내용</option>
			      <option value="w"<c:out value="${scri.searchType eq 'w' ? 'selected' : ''}"/>>작성자</option>
			      <option value="tc"<c:out value="${scri.searchType eq 'tc' ? 'selected' : ''}"/>>제목+내용</option>
			    </select>
				</div>
				
				<div class="col-xs-10 col-sm-10">
					<div class="input-group">
				    <input type="text" name="keyword" id="keywordInput" value="${scri.keyword}" class="form-control"/>
				    <span class="input-group-btn">
				    	<button id="searchBtn" type="button" class="btn btn-default">검색</button>
				    </span>  
				  </div>
				</div>
				
			    <script>
			      $(function(){
			        $('#searchBtn').click(function() {
			          self.location = "list" + '${pageMaker.makeQuery(1)}' + "&searchType=" + $("select option:selected").val() + "&keyword=" + encodeURIComponent($('#keywordInput').val());
			        });
			      });   
			    </script>
  		</div>

				<div id="paging">
					<ul>
						<c:if test="${pageMaker.prev}">
							<li><a href="list${pageMaker.makeSearch(pageMaker.startPage - 1)}">이전</a></li>
						</c:if>

						<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
							<li <c:out value="${pageMaker.cri.page == idx ? 'class=info' : ''}" />>
							<a href="list${pageMaker.makeSearch(idx)}">${idx}</a></li>
						</c:forEach>

						<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
							<li><a
								href="list${pageMaker.makeSearch(pageMaker.endPage + 1)}">다음</a></li>
						</c:if>
					</ul>
				</div>
			</form>
			</div>
	</div>
</body>
</html>