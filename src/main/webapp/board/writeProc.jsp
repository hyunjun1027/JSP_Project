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
	Logger logger = LogManager.getLogger("/board/writeProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	boolean bSuccess = false;
	String errorMessage = "";

	
	String title = HttpUtil.get(request, "title", "");
	String content = HttpUtil.get(request, "content", "");
	
	logger.info("Title: " + title);
	logger.info("Content: " + content);
	
	if(!StringUtil.isEmpty(title) && !StringUtil.isEmpty(content)){
		
		Board board = new Board();
		BoardDao boardDao = new BoardDao();
		
		board.setUser_id(cookieUserId);
		board.setBoard_title(title);
		board.setBoard_content(content);
		
		if(boardDao.boardInsert(board) > 0){
			bSuccess = true;
		}else{
			errorMessage = "게시물 등록 중 오류가 발생하였습니다.";
		}
	}else{
		errorMessage = "게시물 등록시 필요한 값이 올바르지 않습니다.";
	}
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
<%
	if(bSuccess == true){
%>	
		//성공시
		alert("게시물이 등록되었습니다.");
		location.href = "/board/board.jsp";
<%
	}else{
%>
		//실패시
		alert("<%= errorMessage %>");
		location.href = "/board/writeForm.jsp";	
<%
	}
%>
	
	});
</script>
</head>
<body>

</body>
</html>