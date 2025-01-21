<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>

<%
	Logger logger = LogManager.getLogger("/board/deleteProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	
	String errorMessage = "";
	
	boolean bSuccess = false;
	
	if(boardSeq > 0){
		
		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(boardSeq);
		
		if(board != null){
			
			if(StringUtil.equals(cookieUserId, board.getUser_id())){
				
				if(boardDao.boardDelete(boardSeq) > 0){
					
					bSuccess = true;
					
				}else{
					errorMessage = "게시글 삭제중 오류가 발생하였습니다.";
				}
					
			}else{
				errorMessage = "사용자의 게시글이 아닙니다.";
			}
			
		}else{
			errorMessage = "해당 게시글이 존재하지 않습니다.";
		}
		
	}else{
		errorMessage = "게시물 번호가 올바르지 않습니다.";
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 삭제</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
<%
	if(bSuccess == true){
%>
		alert("게시물이 삭제되었습니다.");	
<%
	}else{
%>
		alert("<%=errorMessage%>");
<%
	}
%>
		location.href = "/board/board.jsp";
	});
</script>
</head>
<body>

</body>
</html>