<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.dao.LikeyDao"%>
<%@page import="com.sist.web.model.Comment"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.web.dao.CommentDao"%>

<%
   Logger logger = LogManager.getLogger("/board/view.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
   long commSeq = HttpUtil.get(request, "commSeq", (long)0);
   String searchType = HttpUtil.get(request, "searchType", "");
   String searchValue = HttpUtil.get(request, "searchValue", "");
   long curPage = HttpUtil.get(request, "curPage", (long) 1);      // 되돌아갈 페이지의 정보
   
   BoardDao boardDao = new BoardDao();
   Board board = boardDao.boardSelect(boardSeq);

   List<Comment> list = null;
   CommentDao commentDao = new CommentDao();
   
   list = commentDao.commentList(boardSeq);
   
   long commtotalcount = 0;
   
   
   if (board != null) {
      boardDao.boardReadCntPlus(boardSeq); // 조회수 증가
   }

   
   //로그인여부확인
   boolean isLoggedIn = (cookieUserId != null && !cookieUserId.isEmpty());
%>

<html>
<head>
<%@ include file="/include/head.jsp" %>
<style>
@charset "UTF-8";
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    color: #333;
    display: flex;
    flex-direction: column;
}

header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #fff;
    padding: 20px;
    border-bottom: 1px solid #ddd;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
}

.logo img {
    height: 40px;
}

.content {
   padding: 160px 240px 100px; /* 헤더 아래로 여백 추가 */
   text-align: left;
   background-color: white;
   border-radius: 10px;
   box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
   width: 100%; /* 전체 너비 사용 */
   margin: 0; /* 기본 마진 제거 */
}

.post-title {
    font-size: 28px;
    margin-bottom: 10px;
}

.post-meta {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}

.post-meta img {
    border-radius: 50%;
    width: 40px;
    height: 40px;
    margin-right: 10px;
}

.post-meta span {
    font-size: 14px;
    color: #777;
}

.post-content {
    font-size: 16px;
    margin-top: 10px;
    color: #333;
}

.post-content img {
    height: 200px;
}

.comments-section {
    margin-top: 30px;
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 10px;
}

.comments-section h3 {
    margin-bottom: 10px;
    font-size: 20px;
    color: #00a884;
}

.comment {
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #fff;
}

.comment-input {
    display: flex;
    align-items: center; /* 수직 중앙 정렬 */
    margin-top: 10px;
}

.comment-input textarea {
    width: 100%;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 14px;
    resize: none;
    height: 60px;
}

.comment-input button {
    padding: 10px;
    background-color: #00a884;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.footer {
    text-align: center;
    margin-top: auto;
    padding: 20px;
    background-color: #fff;
}

.footer p {
    font-size: 14px;
    color: #777;
}

.login-message {
    margin-bottom: 20px;
    font-size: 14px;
    color: #777;
}

.post-list {
    margin-top: 20px;
    padding: 20px 240px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #fff;
    display: flex;
    justify-content: end;
}

.post-list-item {
    padding: 10px 0;
    border-bottom: 1px solid #ddd;
}

.post-list-item:last-child {
    border-bottom: none;
}

.post-list-item span {
    color: #00a884;
    cursor: pointer;
}

#btnComm {
   margin: 10px 0px; 
   background-color: #00a884; 
   color: white; 
   border: none; 
   border-radius: 5px; 
   padding: 10px 30px; 
   cursor: pointer;
}

.btnList {
    background-color: #00a884; 
    color: white; 
    border: none; 
    border-radius: 5px;
    padding: 10px; 
    cursor: pointer;
	margin-right: 10px
}

.btnLikey {
    background-color: #8bd145; 
    color: white; 
    border: none; 
    border-radius: 5px;
    margin: 40px 0px 0px 0px;
    padding: 10px; 
    cursor: pointer;
}
.comment-section{
    padding: 20px 240px;
}

.comment {
    background-color: #f9f9f9;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 10px;
    border: 1px solid #ddd;

}

.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.comment-header strong {
    font-size: 16px;
    color: #333;
}

.comment-date {
    font-size: 12px;
    color: #777;
}

.comment-content {
    margin-top: 5px;
    font-size: 14px;
    color: #333;
}

.comment-actions {
    margin: 10px 0;
    display: flex;
    justify-content: end;
}

.comment-actions button {
    background-color: #00a884;
    color: white;
    border: none;
    border-radius: 5px;
    padding: 5px 10px;
    cursor: pointer;
    font-size: 12px;
    margin-right: 10px;
}

.comment-actions button:last-child{

    margin-right: 0px;
}

.comment-btn{
    display: flex;
    justify-content: end;
	margin-right: 10px;
}
	

	
</style>
<script>

//CheckAjax 함수화
function LikeCheckAjax(){
	$.ajax({       		
		 type:"POST",
		 url:"/likey/boardLikeCheckAjax.jsp",
		 data:{
			 userId: $("#userId").val(),
			 boardSeq: $("#boardSeq").val()
		 },
		 datatype:"JSON",
		 success:function(obj){
			 var data = JSON.parse(obj);
			 
				if(data.flag == 0){
					$("#likeCheck").val(0);
					$("#Likeyimg").text("🤍");
					return;
					
				}else if(data.flag == 1){
					$("#likeCheck").val(1);
					$("#Likeyimg").text("🩷");
					return;
					
				}else if(data.flag == -1){
                    // 로그인하지 않은 사용자
                    $("#likeCheck").val(0);
                    $("#Likeyimg").text("🤍");
                    
                } else {
                    alert("오류가 발생하였습니다.");
                }      			 
		 },
		 error:function(xhr, status, error){
			 return;
		 }
		 
	});
};

$(document).ready(function() {
	
<%
    
    //총 댓글수 조회
    commtotalcount = boardDao.commentTotalCount(boardSeq);    
    //LOG
    logger.debug("commtotalcount: " + commtotalcount);
    
    
%>
	
    //댓글작성
    $("#btnComm").on("click", function(){
      var isLoggedIn = <%= isLoggedIn %>;
      if (!isLoggedIn) {
          alert("댓글 작성은 로그인 후 이용 가능합니다.");
          return;
      }
   	 if($.trim($("#commenttext").val()).length <= 0){        		 
   		 alert("댓글을 입력하세요.");
   		 return;
   	 }
   	 
   	 $("#comment").val($("#commenttext").val());
   	 
   	 document.boardForm.action = "/comment/commentProc.jsp";
   	 document.boardForm.submit();
   	 
    });
    
    //댓글 삭제
	$(document).on("click", ".btnCommDelete", function() {
	    var commSeq = $(this).data("commseq");
	    var boardSeq = $(this).data("boardseq");
	
	    if (confirm("댓글을 삭제하시겠습니까?")) {
	        $("#commSeq").val(commSeq);
	        $("#boardSeq").val(boardSeq);
	        document.boardForm.action = "/comment/commentDeleteProc.jsp";
	        document.boardForm.submit();
	    }
	});
	

<%
   if (board == null) {
%>
      alert("조회하신 게시글이 존재하지 않습니다.");
      document.boardForm.action = "/board/board.jsp";
      document.boardForm.submit();

<%
   }
   else {
%>
	
	  LikeCheckAjax();
	  


      $("#btnList").on("click", function() {
         document.boardForm.action = "/board/board.jsp";
         document.boardForm.submit();
      });
<%
      if (StringUtil.equals(cookieUserId, board.getUser_id())) {
%>			
		 //게시글 수정
         $("#btnUpdate").on("click", function() {
        	
            document.boardForm.action = "/board/update.jsp";
            document.boardForm.submit();
         });
         
         //게시글 삭제
         $("#btnDelete").on("click", function() {
            if (confirm("게시글을 삭제하시겠습니까?")) {
               document.boardForm.action = "/board/deleteProc.jsp";
               document.boardForm.submit();
            }
         });  
         
<%
      }
   }
%>
		//좋아요
		$("#btnLikey").on("click", function(){
			var isLoggedIn = <%= isLoggedIn %>;
			if (!isLoggedIn) {
				alert("좋아요는 로그인 후 이용 가능합니다.");
				return;
			}
			
			$.ajax({       		
			type:"POST",
			url:"/likey/boardLikeAjax.jsp",
			data:{
			 userId: $("#userId").val(),
			 boardSeq: $("#boardSeq").val(),
			 likeCheck: $("#likeCheck").val()
			},
			datatype:"JSON",
			success:function(obj){
			 var data = JSON.parse(obj);
			 
				if(data.flag == 0){
					
					//alert("증가 성공");
					
				}else if(data.flag == 1){
					//alert("증가실패");
					
				}else if(data.flag == 2){
					//alert("감소 성공");
					
				}else if(data.flag == 3){
					//alert("감소 실패");
					
				}
				
				LikeCheckAjax();
			},
			error:function(xhr, status, error){
			 return;
			}
	
		});
	
	 });

});

</script>

</head>

<%
   if (board != null) {
%>
<body>
    <%@ include file="/include/navigation.jsp" %>

    <div class="content">
        <h1 class="post-title"><%= board.getBoard_title() %></h1>
        
        <div class="post-meta">
            <img src="/resources/images/noimage.jpg" alt="작성자 프로필 이미지">
            <span><%= board.getUser_nickname() %> | <%= board.getBoard_category() %> | <%= board.getBoard_modi_date() %> </span>
        </div>

        <div class="post-content">
            <p><%= StringUtil.replace(board.getBoard_content(), "\n", "<br>") %></p>
        </div>
        
       <button type="button" id="btnLikey" class="btnLikey" style="text-align: center;">좋아요 <span id="Likeyimg"></span></button>
    
    </div>
    
        <div class="post-list">
        <button class="btnList" id="btnList">목록</button>
<%
   if (StringUtil.equals(cookieUserId, board.getUser_id())) {
%>
        <button class="btnList" id="btnUpdate">수정</button>
        <button class="btnList" id="btnDelete">삭제</button>
<%
   }
%>

<!------------------------------comment-------------------------------------------->

    </div>

    <div class="comment-section">
        	<div class="comment-header">
                <h3>댓글 [<%= commtotalcount %>]</h3>
            </div>
            <br>
    
<%

	if(list != null && list.size() > 0) {
		for (int i = 0; i < list.size(); i++) {
			Comment comment = list.get(i);
%> 
      
            <div class="comment">
                <div class="comment-header">
                    <strong><%= comment.getUser_nicname() %></strong>
                    <span class="comment-date"><%= comment.getComm_modi_date() %></span>
                </div>
                <p class="comment-content"><%= comment.getComm_content() %></p>
			<div class="comment-actions">
<%				
				// 로그인한 사용자가 댓글 작성자인지 확인			
				if (StringUtil.equals(cookieUserId, comment.getUser_id())) {
%>	

				<!-- <button type="button" id="btnCommUpdate" class="btnCommUpdate" name="btnCommUpdate">수정</button> -->
				<button type="button" class="btnCommDelete" data-commseq="<%= comment.getComm_seq() %>" data-boardseq="<%= boardSeq %>">삭제</button>
<%
}
%>
			</div>


            </div>
   <%
      }
   }else {
	   
   %>
            
            <div class="comment">
                <p class="comment-content">작성된 댓글이 없습니다. 댓글을 작성해보세요! 🙄<p>
            </div>
 <%
   }
 %>           

            <div class="comment-input">
                <textarea name="commenttext" id="commenttext" placeholder="댓글을 입력하세요."></textarea>
            </div>
            <div class="comment-btn">
                <button id="btnComm" name="btnComm" type="button">작성</button>
            </div>

        </div>



        <div class="footer">
            <p>Mini Project © 2024</p>
        </div>
<%
   }
%>   
    

<form name="boardForm" method="post"> 	 
    <input type="hidden" id="commUpdate" name="commUpdate" value="">
    <input type="hidden" id="comment" name="comment" value="">
    <input type="hidden" id="likeCheck" name="likeCheck" value="">
    <input type="hidden" id="userId" name="userId" value="<%= cookieUserId %>">
    <input type="hidden" id="boardSeq" name="boardSeq" value="<%= boardSeq %>">
    <input type="hidden" id="commSeq" name="commSeq" value="">
    <input type="hidden" name="searchType" value="<%= searchType %>">
    <input type="hidden" name="searchValue" value="<%= searchValue %>">
    <input type="hidden" name="curPage" value="<%= curPage %>">
</form>


</body>
</html>

