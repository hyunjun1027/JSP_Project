<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.model.Comment"%>
<%@ page import="com.sist.web.dao.CommentDao"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.sist.web.model.Board"%>
<%@page import="com.sist.web.dao.BoardDao"%>
<%
    Logger logger = LogManager.getLogger("/comment/commentDeleteProc.jsp");
    HttpUtil.requestLogString(request, logger);
    
    String cookieUserId = CookieUtil.getValue(request, "USER_ID");
    long commSeq = HttpUtil.get(request, "commSeq", (long)0);
    long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
    
    logger.debug("댓글 삭제 : commSeq : " + commSeq +
    						", boardSeq : " + boardSeq + ", cookieUserId : " + cookieUserId);
    
    boolean bSuccess = false;
    String errorMessage = "";

    if(commSeq > 0 && boardSeq > 0){
        CommentDao commentDao = new CommentDao();
        Comment comment = commentDao.commentSelect(boardSeq, commSeq, cookieUserId);
		Board board = new Board();
		BoardDao boardDao = new BoardDao();
        
        if(comment != null){
        	
            if(StringUtil.equals(cookieUserId, comment.getUser_id())){
            
            	if(commentDao.commentDelete(comment) > 0){
            		
        			if(boardDao.boardCommentCntMinus(boardSeq) > 0){
        				
        				bSuccess = true;
        				
        			}else{
        				errorMessage = "오류가 발생하였습니다.";
        			}
        			
                } else {
                    errorMessage = "댓글 삭제 중 오류가 발생하였습니다.";
                }
            } else {
                errorMessage = "사용자의 댓글이 아닙니다.";
            }
        } else {
            errorMessage = "해당 댓글이 존재하지 않습니다.";
        }
    } else {
        errorMessage = "댓글 번호 또는 게시글 번호가 올바르지 않습니다.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>댓글 삭제</title>
    <%@ include file="/include/head.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function(){
            <%
                if(bSuccess == true){
            %>
                    alert("댓글이 삭제되었습니다.");	
                    location.href = "/board/view.jsp?boardSeq=<%= boardSeq %>";
            <%
                } else {
            %>
                    alert("<%= errorMessage %>");
                    location.href = "/board/view.jsp?boardSeq=<%= boardSeq %>";
            <%
                }
            %>
        });
    </script>


</head>

<body>
<form name="boardForm" method="post"> 	 
	<input type="hidden" id="comment" name="comment" value="">
	<input type="hidden" id="likeCheck" name="likeCheck" value="">
	<input type="hidden" id="userId" name="userId" value="<%= cookieUserId %>">
	<input type="hidden" id="boardSeq" name="boardSeq" value="<%= boardSeq %>">
	<input type="hidden" id="commSeq" name="commSeq" value="<%= commSeq %>">
</form>
</body>

</html>