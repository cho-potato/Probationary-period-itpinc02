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
	<form id="frm" name="frm" enctype="multipart/form-data">
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
				<td>
					${map.IDX }
					<input type="hidden" id="IDX" name="IDX" value="${map.IDX }">
				</td>
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
				<td colspan="3">
					<input type="text" id="TITLE" name="TITLE" class="wdp_90" value="${map.TITLE }">
				</td>
			</tr>
			<tr>
				<td colspan="4" class="view_text">
					<textarea rows="20" cols="100" title="내용" id="CONTENTS" name="CONTENTS">${map.CONTENTS }</textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
					<div id="fileDiv">
					<c:choose> 
						<c:when test="${fn:length(list)>0 }">
						<c:forEach var="row" items="${list }" varStatus="var">
								<p>
                                    <input type="hidden" id="IDX" name="IDX_${var.index }" value="${row.IDX }">
                                    <a href="#this" id="name_${var.index }" name="name_${var.index }">${row.ORIGINAL_FILE_NAME }</a>
                                    <input type="file" id="file_${var.index }" name="file_${var.index }"> 
                                    (${row.FILE_SIZE }kb)
                                    <a href="#this" class="btn" id="delete_${var.index }" name="delete_${var.index }">삭제</a>
                                </p>
						</c:forEach>
						</c:when>
							<c:otherwise>첨부된 파일이 없습니다!</c:otherwise>
					</c:choose>
					</div>
				</td>
			</tr>
		</tbody>
		</table>
	</form>
	<a href="#this" class="btn" id="addFile">파일추가</a>
	<a href="#this" class="btn" id="list">목록으로</a>
	<a href="#this" class="btn" id="update">저장하기</a>
	<a href="#this" class="btn" id="delete">삭제하기</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
	
	var gfv_count = "${fn:length(list)+1}";
		
	$(document).ready(function(){
		
		$("#list").on("click",function(e){
			e.preventDefault();
			fn_openBoardList();
		});
		
		$("#update").on("click",function(e){
			e.preventDefault();
			fn_updateBoard();
		});
		
		$("#delete").on("click",function(e){
			e.preventDefault();
			fn_deleteBoard();
		});
		
		$("#addFile").on("click", function(e){   //파일 추가
			e.preventDefault();
			fn_addFile();
		});
		
		$("a[name^='delete']").on("click", function(e){
			e.preventDefault();
			fn_deleteFile($(this));
		});
	});
	
	function fn_openBoardList()
	{
		var comSubmit = new ComSubmit();
		comSubmit.setUrl("<c:url value='/sample/openBoardList.do'/>");
		comSubmit.submit();
	}
	
	function fn_updateBoard()
	{
		var comSubmit = new ComSubmit("frm");
		comSubmit.setUrl("<c:url value='/sample/updateBoard.do'/>");
		comSubmit.submit();
	}
	
	function fn_deleteBoard()
	{
		var comSubmit = new ComSubmit();
		comSubmit.setUrl("<c:url value='/sample/deleteBoard.do'/>");
		comSubmit.addParam("IDX",$("#IDX").val());
		comSubmit.submit();
	}
	
	function fn_addFile()
	{
		var str = "<p><input type='file' id='file_"+(gfv_count)+"' name='file_"+(gfv_count)+"'>"+
       			"<a href='#this' class='btn' id='delete_"+(gfv_count)+"' name='delete_"+(gfv_count)+"'>삭제</a></p>";

		$("#fileDiv").append(str);
		$("#delete_"+(gfv_count++)).on("click", function(e){
			e.preventDefault();
			fn_deleteFile($(this));
		});
	}
	
	//boardWrite.jsp 와 비교
	
	/* function fn_addFile(){
        var str = "<p><input type='file' name='file_"+(gfv_count++)+"'><a href='#this' class='btn' name='delete'>삭제</a></p>";
        $("#fileDiv").append(str);
        $("a[name='delete']").on("click", function(e){ //삭제 버튼
            e.preventDefault();
            fn_deleteFile($(this));
        });
	} */
    
	
	function fn_deleteFile(obj)
	{
		obj.parent().remove();
	}
		
	</script>

</body>
</html>