<!-- itpinc02 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file ="/WEB-INF/include/include-header.jspf" %>

</head>
<body>
	<h2>게시판 목록</h2>
	<form>
		<select id="category" >
			<option value="0">선택하십쇼</option>
			<option value="idx">글번호</option>
			<option value="title">제목</option>
			<option value="contents">내용</option>
		</select>
		<input type="text" id="search"/>
		<a href="#this" class="btn" id="btnSearch">조회</a>
	</form>
	<table class="board_list">
		<colgroup>
			<col width="10%"/>
			<col width="*"/>
			<col width="15%"/>
			<col width="20%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">
				<input type="checkbox" id="checkAll" onclick="fn_checkAll(this)">
				</th>
				<th scope="col">글번호</th>
				<th scope="col">미리보기</th>
				<th scope="col">제목</th>
				<th scope="col">조회수</th>
				<th scope="col">작성일</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${fn:length(list) > 0}">  <!-- boolean -->
					<c:forEach items="${list }" var="row" varStatus="status">
						<tr>
							<td>
								<input type="checkbox" name="checkBox">
							</td>
							<td>${row.IDX }</td>
							<td class=preview>
							<a href="javascript:fn_preview(${row.IDX})" class="btn" id="btnPreview">미리보기</a>
							<!-- <input type="button" value="미리보기" onclick="openChild()"> -->
							
							</td>
							<td class="title">
								<a href="#this" name="title">${row.TITLE }</a>
								<input type="hidden" id="IDX" value="${row.IDX }">
							</td>
							<td>${row.HIT_CNT }</td>
							<td>${row.CREA_DTM }</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="4">조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	
	<c:if test="${not empty paginationInfo }">
		<ui:pagination paginationInfo = "${paginationInfo }" type="text" jsFunction="fn_search"/>
	</c:if>
	<input type="hidden" id="currentPageNo" name="currentPageNo"/>
	<input type="hidden" id="currentCategory" name="currentCategory" value="${category }"/>
	<input type="hidden" id="currentSearch" name="currentSearch" value="${search }"/>
	<br/>
	<a href="#this" class="btn" id="write">글쓰기</a>
	<a href="#this" class="btn" id="deleteChecked">삭제</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_openBoardWrite();
			});	
			
			$("a[name='title']").on("click", function(e){ //제목 
				e.preventDefault();
				fn_openBoardDetail($(this)); //$(this)의미 : jQuery <a 태그의미
			});
			
			$("#btnSearch").on("click", function(e){ //조회하기
				e.preventDefault();
				fn_search1($(this));
				//fn_openBoardDetail($(this));
			});	

			$("#checkAll").on("click", function() {
			    var isChecked = $(this).prop("checked");
			    $("input[name='checkBox']").prop("checked", isChecked);
			});
			/*
			$("input[name='checkBox']").on("click", function(e) {
				e.preventDefault();
				fn_isChecked();
			});
			*/
			/*
			$("#deleteChecked").on("click", function() {
				var checkedIdx = [];
				
				$("input[name='checkBox']:checked").each(function() {
				checkedIdx.push($(this).val());
				fn_deleteToChecked();
				});
			});
			*/
			/* comSubmit 있으니까 form을 만들 필요는 없음 ,,,
			$("#deleteChecked").on("click", function() {
			    var form = document.createElement("form");
			    form.setAttribute("method", "post");
			    form.setAttribute("action", "/sample/deleteBoard.do");
			    $("input[name='checkBox']:checked").each(function() {
			        var input = document.createElement("input");
			        input.setAttribute("type", "hidden");
			        input.setAttribute("name", "checkBox");
			        input.setAttribute("value", $(this).val());
			        form.appendChild(input);
			    });
			    document.body.appendChild(form);
			    form.submit();
			});
			*/
			$("#deleteChecked").on("click", function() {
			    var checkedValues = $("input[name='checkBox']:checked").map(function() {
			        return this.value;
			    }).get();
			    if (checkedValues.length > 0) {
			        var comSubmit = new ComSubmit();
			        comSubmit.setUrl("/sample/deleteBoard.do");
			        comSubmit.addParam("checkedValues", checkedValues);
			        comSubmit.submit();
			    } else {
			        alert("한 개 이상의 체크박스를 선택해주세요");
			    }
			});
		});
		

		function fn_openBoardWrite(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardWrite.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail.do' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val()); // key와 value값
			comSubmit.submit();
		}

		function fn_search(pageNo)
		{
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
			comSubmit.addParam("currentPageNo", pageNo);
			comSubmit.addParam("category", $("#currentCategory").val());
			comSubmit.addParam("search", $("#currentSearch").val());

			comSubmit.submit();
		}
		
		// 검색결과의 첫번쨰 페이지 가져오기
		function fn_search1(obj){
			var comSubmit = new ComSubmit();

			comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
			// comSubmit.addParam("currentPageNo", "1"); AbstractDAO때문에 초기화 (1로 지정) 되니까 없어도 됨 ,,,
			comSubmit.addParam("category", obj.parent().find("#category").val());
			comSubmit.addParam("search", obj.parent().find("#search").val());
			comSubmit.submit();
		}
		// common.js 라는 공통단을 이용해서 팝업 띄움
		function fn_preview(idx) {
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail3.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.popup();
		}
		
		/* 공통단(common.js)에 팝업기능이 추가됐을 때, 그 기능활용해서 만들어보기
		function fn_preview(idx) {
			var url = "<c:url value='/sample/openBoardDetail3.do?IDX="+idx+"' />";
			var name = "popup";
			var option = "width=500,height=500,resizable=yes";
			
			window.open(url,name,option);
		}
		*/
		/* 게시글 상세보기 전체를 가져오는걸 요구한게 아님
 		function fn_preview(idx) {
			var url = "<c:url value='/sample/openBoardDetail.do?IDX="+idx+"' />";
			var name = "popup";
			var option = "width=500,height=500,resizable=yes";
			
			window.open(url,name,option);
		} 
		*/
		
		function fn_checkAll(){
			if(document.getElementById("checkAll").checked==true){
				document.getElementsByName("checkBox").checked=true;

			}
			if(document.getElementById("checkAll").checked==false){
				document.getElementsByName("checkBox").checked=false;  
			}
		}
		/*
		function fn_deleteToChecked() {
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/sample/deleteBoard.do' />");
			comSubmit.submit();
		}
		*/
	</script>	
</body>
</html>