<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.model.User"%>


<%
	Logger logger = LogManager.getLogger("/board/updateProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	

	
	String title = HttpUtil.get(request, "title", "");
	String content = HttpUtil.get(request, "content", "");

	logger.debug("1 " + boardSeq);
	logger.debug("2 " + title);
	logger.debug("3 " + content);
	
	String errorMessage = "";
	boolean bSuccess = false;
	
	if(boardSeq > 0 && !StringUtil.isEmpty(title) && !StringUtil.isEmpty(content)){
		
		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(boardSeq);
		
		if(board != null){
			
			if(StringUtil.equals(cookieUserId, board.getUser_id())){
				
				board.setBoard_seq(boardSeq);
				board.setBoard_title(title);
				board.setBoard_content(content);
				
				if(boardDao.boardUpdate(board) > 0){
					
					bSuccess = true;
					
				}else{
					errorMessage = "게시물 수정중 오류가 발생하였습니다.";
				}
				
			}else{
				errorMessage = "회원님의 게시글이 아닙니다.";
			}
			
		}else{
			errorMessage = "게시물이 존재하지 않습니다.";
		}
		
	}else{
		
		errorMessage = "게시물 수정 값이 올바르지 않습니다.";
		
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="/include/head.jsp" %>
<script>
	
	$(document).ready(function(){
		
<%
	if(bSuccess == true){
%>
		alert("게시글이 수정되었습니다.");
		document.updateForm.action = "/board/view.jsp";
		document.updateForm.submit();		
<%
	}else{
%>
		alert("<%=errorMessage%>");
		document.updateForm.action = "/board/board.jsp";
<%
	}
%>
		
	});

</script>

	<form name="updateForm" id="updateForm" method="post">
		<input type="hidden" name="boardSeq" value="<%= boardSeq %>">
		<input type="hidden" name="searchType" value="<%= searchType %>">
		<input type="hidden" name="searchValue" value="<%= searchValue %>">
		<input type="hidden" name="curPage" value="<%= curPage %>">
   </form>
</body>
</html>