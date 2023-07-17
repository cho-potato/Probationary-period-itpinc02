<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<table class="board_view">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		<caption>게시글 상세</caption>
		<tbody>
			<tr>
				<th scope="row">글 번호</th>
				<td>${map.IDX }</td>
				<th scope="row">조회수</th>
				<td>${map.HIT_CNT }</td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td>${map.CREA_ID }</td>
				<th scope="row">작성시간</th>
				<td>${map.CREA_DTM }</td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td colspan="3">${map.TITLE }</td>
			</tr>
			<tr>
				<td colspan="4">${map.CONTENTS }</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
				<c:choose>
					<c:when test="${fn:length(list) >0 }"> <!--  boolean  -->
						<c:forEach var="row" items="${list}">
							<input type="hidden" id="IDX" value="${row.IDX }">
							<a href="#this" name="file">${row.ORIGINAL_FILE_NAME }</a>
							(${row.FILE_SIZE }kb)
						</c:forEach>
					</c:when>
						<c:otherwise>첨부된 파일이 없습니다.!</c:otherwise>
				</c:choose>
				</td>
			</tr>
		</tbody>
	</table>
	
	<form>
	<a href="#this" class="btn" id="list">목록으로</a>
	<a href="#this" class="btn" id="update">수정하기</a>
	<a href="#this" class="btn" id="delete">삭제하기</a>

	<a href="#this" class="btn" id="prev">이전페이지</a>
	<a href="#this" class="btn" id="next">다음페이지</a>
	</form>

	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_openBoardList();
			});
			
			$("#update").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_openBoardUpdate();
			});

			$("#delete").on("click", function(e){ //삭제하기 버튼
				e.preventDefault();
				alert("삭제하시겠습니까?");
				fn_deleteBoard();
			});

			$("#prev").on("click", function(e){ //이전페이지 버튼
				e.preventDefault();
				fn_openBoardPrev($(this));
			});

			$("#next").on("click", function(e){ //다음페이지 버튼
				e.preventDefault();
				fn_openBoardNext($(this));
			});
			
			$("a[name='file']").on("click", function(e){ //파일이름
				e.preventDefault();
				fn_downloadFile($(this));
			});
		});
		
		function fn_openBoardList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardUpdate(){
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardUpdate.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}

		function fn_deleteBoard(){
			var idx = "${map.IDX}";
			
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/deleteBoard.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();

		}

		function fn_openBoardPrev() {
			var idx = "${map.IDX}"; // 현재 값
			console.log(idx);
			
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail2.do' />");
			// comSubmit.addParam("prev", obj.parent().find("#prev").val()); // 이건 prev에 값이 담겨있을 떄 사용 가능 
			comSubmit.addParam("IDX", idx); // IDX를 넘겨줌 - mapper(SampleSQL.xml)에
			comSubmit.submit();
		}

		
		function fn_openBoardNext() {
			var idx = "${map.IDX}"; // 현재값 가져와야되느거 ,,, 
			console.log(idx);

			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/sample/openBoardDetail1.do' />");
			// comSubmit.addParam("next", obj.parent().find("#next").val()); // 이건 next에 값이 담겨있을 떄 사용 가능 
			comSubmit.addParam("IDX", idx); // IDX를 넘겨줌 - mapper(SampleSQL.xml)에
			comSubmit.submit();
		}

		
		function fn_downloadFile(obj)
		{
			var idx = obj.parent().find("#IDX").val();
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/common/downloadFile.do'/>");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
	</script>
</body>
</html>