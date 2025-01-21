<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
header {
   display: flex;
   justify-content: space-between;
   align-items: center;
   background-color: #fff;
   padding: 20px 240px;
   border-bottom: 1px solid #ddd;
}

.logo img {
    padding-top: 6px;
	height: 40px;
}

.login button {
   background-color: #00a884;
   color: #fff;
   padding: 10px 20px;
   border: none;
   border-radius: 5px;
   cursor: pointer;
}

nav ul {
   list-style-type: none;
   display: flex;
   gap: 20px;
}

nav ul li {
   display: inline;
}

nav ul li a {
   text-decoration: none;
   color: #333;
   font-weight: bold;
}

nav ul li a:hover{
	color: #00a884;
	transition-duration: 0.2s;
}

.auth-buttons {
   top: 20px;
   right: 20px;
}

.auth-buttons button {
   background-color: #00a884;
   color: white;
   padding: 10px 20px;
   border: none;
   border-radius: 5px;
   cursor: pointer;
}

.auth-buttons #madal-loginOut-btn{
	background-color: red;
}

/* 로그인 모달 */
.modal {
   display: none;
   position: fixed;
   z-index: 1;
   left: 0;
   top: 0;
   width: 100%;
   height: 100%;
   background-color: rgba(0, 0, 0, 0.5);
   justify-content: center;
   align-items: center;
}

.modal-content {
   background-color: white;
   padding: 20px;
   border-radius: 10px;
   width: 100%;
   max-width: 350px; 
   box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.modal-content h1{
text-align: center;
	padding-top: 20px;
	padding-bottom: 30px;
}


.login-form input {
    width: 100%;
    padding: 10px 2px;
    margin-top: 5px;
    margin-bottom: 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 14px;
}

.madal-login-btn {
    width: 100%;
    padding: 10px;
    background-color: #00a884;
    border: none;
    border-radius: 5px;
    color: white;
    font-size: 20px;
    cursor: pointer;
    margin-top: 30px;
    margin-bottom: 20px;
}

.login-btn {
    width: 100%;
    padding: 10px;
    background-color: #00a884;
    border: none;
    border-radius: 5px;
    color: white;
    font-size: 20px;
    cursor: pointer;
    margin-top: 30px;
    margin-bottom: 20px;
}

.extra-options {
   display: flex;
   justify-content: space-between;
   margin: 10px 0;
   font-size: 14px;
}

.extra-options a {
   color: #555;
   text-decoration: none;
}

/* 닫기 버튼 
.close-btn {
   background-color: #00a884;
   color: white;
   padding: 5px;
   border: none;
   border-radius: 5px;
   cursor: pointer;
   font-size: 14px;
   margin-top: 10px;
}
*/

.login-form label{
	font-weight: bold;
}


</style>

</head>
<body>
<%
	if(StringUtil.isEmpty(CookieUtil.getValue(request, "USER_ID"))){

%>
   <header>
      <div class="logo">
         <a href="/index.jsp"><img src="/resources/images/2.png" alt="로고"></a>
      </div>
      <nav>
         <ul>
            <li><a href="/board/board.jsp">전체보기</a></li>
            <li><a href="#">한식</a></li>
            <li><a href="#">중식</a></li>
            <li><a href="#">일식</a></li>
            <li><a href="#">양식</a></li>
            <li><a href="#">분식</a></li>
            <li><a href="#">기타</a></li>
         </ul>
      </nav>
      <div class="auth-buttons">
         <button id="madal-login-btn">로그인</button>
      </div>
   </header>
 
<%
	}else{
%>
   
   <header>
      <div class="logo">
         <a href="/index.jsp"><img src="/resources/images/2.png" alt="로고"></a>
      </div>
      <nav>
         <ul>
            <li><a href="/board/board.jsp">전체보기</a></li>
            <li><a href="#">한식</a></li>
            <li><a href="#">중식</a></li>
            <li><a href="#">일식</a></li>
            <li><a href="#">양식</a></li>
            <li><a href="#">분식</a></li>
            <li><a href="#">기타</a></li>
         </ul>
      </nav>
      
    <div class="auth-buttons">	   
	    <form action="/user/logoutProc.jsp" method="post" style=" display: inline;">
            <button type="submit" id="madal-loginOut-btn">로그아웃</button>
        </form>
        <button type="button" id="madal-mypage-btn" onclick="location.href='/user/myPage.jsp'">마이페이지</button>
    </div>
    
   </header>
   
<%
	}
%>   

   <div id="login-modal" class="modal">
      <div class="modal-content">
         <h1>로그인</h1>
         <form class="login-form" id="loginForm" name="loginForm" method="post" action="/user/loginProc.jsp">
         	<label id="UserId">아이디</label>
            <input type="text" id="loginUserId" name="loginUserId" placeholder="아이디" required> 
            
            <label id="loginUserPwd">비밀번호</label>
            <input type="password" id="loginUserPwdInput" name="loginUserPwdInput" placeholder="비밀번호" required>
            
            <button type="button" class="login-btn" id="login-btn">로그인</button>
         </form>
         <div class="extra-options">
            <a href="/user/userRegForm.jsp">회원가입</a>
             <a href="/user/userFindForm.jsp">아이디 · 비밀번호 찾기</a>
         </div>
         <input type="hidden" class="close-btn" id="close-modal">
      </div>
   </div>
   
	<script>
		document.addEventListener('DOMContentLoaded', function () {
	    const LoginModalBtn = document.getElementById('madal-login-btn');
	    const loginBtn = document.getElementById('login-btn');
	    const modal = document.getElementById('login-modal');
	    const closeModal = document.getElementById('close-modal');
	    const loginUserId = document.getElementById('loginUserId');
	    const loginUserPwd = document.getElementById('loginUserPwdInput');

	    if (LoginModalBtn) {
	        LoginModalBtn.addEventListener('click', () => {
	            modal.style.display = 'flex';
	            loginUserId.focus();
	        });
	    }

	    if (closeModal) {
	        closeModal.addEventListener('click', () => {
	            modal.style.display = 'none';
	        });
	    }

	    window.addEventListener('click', (event) => {
	        if (event.target === modal) {
	            modal.style.display = 'none';
	        }
	    });

	    if (loginBtn) {
	        loginBtn.addEventListener("click", function (event) {
	            event.preventDefault();
	            fn_loginCheck();
	        });
	    }

	    function fn_loginCheck() {
	        // 아이디 입력 체크
	        if ($.trim($("#loginUserId").val()).length <= 0) {
	            alert("아이디를 입력하세요.");
	            $("#loginUserId").val("");
	            $("#loginUserId").focus();
	            return;
	        }

	        // 비밀번호 입력 체크
	        if ($.trim($("#loginUserPwdInput").val()).length <= 0) {
	            alert("비밀번호를 입력하세요.");
	            $("#loginUserPwdInput").val("");
	            $("#loginUserPwdInput").focus();
	            return;
	        }

	        document.loginForm.submit();
	    }
	});

	</script>


</body>
</html>