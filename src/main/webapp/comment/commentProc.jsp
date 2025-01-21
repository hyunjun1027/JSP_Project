<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.model.Comment"%>
<%@ page import="com.sist.web.dao.CommentDao"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="com.sist.web.db.DBManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.dao.BoardDao"%>

<%
	Logger logger = LogManager.getLogger("/comment/commentProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	long commSeq = HttpUtil.get(request, "commSeq", (long)0);	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	String comment = HttpUtil.get(request, "comment", "");
	
	logger.debug("cookieUserId: " + cookieUserId);
	logger.debug("boardSeq: " + boardSeq);
	logger.debug("comment: " + comment);
	logger.debug("commSeq: " + commSeq);
	
	boolean bSuccess = false;
	String errorMessage = "";
	
	if(!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(comment)){
		
		Comment comm = new Comment();
		CommentDao commentDao = new CommentDao();
		Board board = new Board();
		BoardDao boardDao = new BoardDao();
		
		comm.setBoard_seq(boardSeq);
		comm.setComm_seq(commSeq);
		comm.setUser_id(cookieUserId);
		comm.setComm_content(comment);
		
		if(commentDao.commentInsert(comm) > 0){
			
			if(boardDao.boardCommentCntPlus(boardSeq) > 0){
				
				bSuccess = true;
				
			}else{
				errorMessage = "오류가 발생하였습니다.";
			}
			
		}else{
			errorMessage = "댓글 등록 중 오류가 발생하였습니다.";
		}
	}else{
		errorMessage = "댓글 등록시 필요한 값이 올바르지 않습니다.";
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
		//성공시
		alert("댓글이 등록되었습니다.");
		document.boardForm.action="/board/view.jsp";
		document.boardForm.submit();
		
<%
	}else{
%>
		//실패시
		alert("<%= errorMessage %>");
		location.href = "/board/view.jsp";	
<%
	}
%>
	
	});
</script>
   <form name="boardForm" method="post"> 	 
      <input type="hidden" id="comment" name="comment" value="">
      <input type="hidden" id="likeCheck" name="likeCheck" value="">
      <input type="hidden" id="userId" name="userId" value="<%= cookieUserId %>">
      <input type="hidden" id="boardSeq" name="boardSeq" value="<%= boardSeq %>">
      <input type="hidden" id="commSeq" name="commSeq" value="<%= commSeq %>">
   </form>
</body>
</html>