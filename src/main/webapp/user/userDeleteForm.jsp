<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sist.web.dao.UserDao"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("userUpdateForm.jsp");
   HttpUtil.requestLogString(request, logger);
   
   User user = null;
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   
   if (!StringUtil.isEmpty(cookieUserId)) {
      
      UserDao userDao = new UserDao();
      user = userDao.userSelect(cookieUserId);
      
      if (user == null) {   
         CookieUtil.deleteCookie(request, response, "/", "USER_ID");
         response.sendRedirect("/");
      }
      else {
         if (!StringUtil.equals(user.getUser_status(), "정상")) {
            CookieUtil.deleteCookie(request, response, "/", "USER_ID");
            user = null;
            response.sendRedirect("/");
         }
      }
   }
   
   if (user != null) {
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>    
   
<script>
$(document).ready(function() {
   
});

</script>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .menu {
            width: 25%;
            padding: 20px;
        }
        .menu ul {
            list-style-type: none;
            padding: 0;
        }
        .menu ul li {
            margin-bottom: 10px;
        }
        .menu ul li a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        .menu ul li a:hover {
            color: #007bff;
        }
        .content {
            width: 75%;
            padding: 20px;
        }
        .user-info {
            background-color: #f9f9f9;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }
        .user-info img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 20px;
        }
        .user-info h2 {
            margin: 0;
            font-size: 20px;
        }
        .user-info p {
            margin: 5px 0;
            color: #555;
        }
        .order-status, .user-form {
            background-color: #f9f9f9;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .order-status p {
            color: #888;
            font-size: 14px;
            text-align: center;
        }
        .user-form h3 {
            margin-bottom: 10px;
            font-size: 18px;
        }
        .user-form label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        .user-form input[type="text"], .user-form input[type="password"], .user-form input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .user-form button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .user-form button:hover {
            background-color: #0056b3;
        }
        
        select {
           margin-top: 10px;
           padding: 10px;
          border: 1px solid #ccc;
          border-radius: 5px;
          font-size: 1em;
       }
       
       #btnDelete {
          background-color: #5D5E61;
          color: white;
          padding: 10px;
          border: none;
          cursor: pointer;
          font-size: 1.0em;
          }
    </style>
    <script>
    	
    	$(document).ready(function(){
    		
    		$("#btnDelete").on("click", function(){
    			
    			if($.trim($("#userPwdChk").val()).length <= 0){
    				alert("비밀번호를 입력해주세요.");
					$("#userPwdChk").val("");
					$("#userPwdChk").focus();
					return;
    			}
    			
    			
    			if ($("#userPwdChk").val() != <%= user.getUser_pwd() %>) {
					alert("비밀번호가 일치하지 않습니다.");
					$("#userPwdChk").val("");
					$("#userPwdChk").focus();
					return;
	   		    }
    			
    			if(!confirm("확인을 누르면 회원 탈퇴가 됩니다. 탈퇴 하시겠습니까?")){
    			    alert("취소 되었습니다.");
    			    return;
    			}else{
    			    document.userDeleteForm.submit();
    			}
    			
    			 
    		});
    		
    		
	       
    	});
    
    </script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
    <!-- 왼쪽 메뉴 리스트 -->
    <div class="menu">
        <ul>
            <li><a href="#">1:1 문의</a></li>
            <li><a href="userUpdateForm.jsp">정보 수정</a></li>
            <li><a href="userDeleteProc.jsp">회원탈퇴</a></li>
        </ul>
    </div>

    <!-- 오른쪽 컨텐츠 영역 -->
    <div class="content">
        <!-- 사용자 정보 섹션 -->
        <div class="user-info">
            <img src="https://via.placeholder.com/60" alt="사용자 이미지">
            <div>
               <h2><%= user.getUser_nickname() %> 님 안녕하세요.</h2>
                <p> 게시글 수 : 1 | 댓글 수 : 3</p>
            </div>
        </div>
		
        <!-- 회원 정보 수정 폼 섹션 -->
        <form id="userDeleteForm" name="userDeleteForm" method="post" action="userDeleteProc.jsp">
	        <div class="user-form">            
	           <h3>아이디</h3>
	            <input type="text" id="userId" name="userId" value="<%= user.getUser_id() %>" readonly>
	            <h3>비밀번호</h3>
	             <input type="password" id="userPwdChk" name="userPwdChk" >
	             <button type="button" name="btnDelete" id="btnDelete">탈퇴하기</button>
	        </div>
	    </form>
    </div>
</div>

</body>
<%
   }else{
%>
	<script>
		alert("잘못된 이용자 입니다.");
		location.href="/";
	</script>
<%
	}
%>
</html>

