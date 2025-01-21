<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("usrUpdateForm.jsp");
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
   
   if (user != null) {      // 유저 정보가 있을 때 보여줌
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
   
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
       
       #btnUpdate {
          background-color: #00a884;
          color: white;
          padding: 10px;
          border: none;
          cursor: pointer;
          font-size: 1.0em;
          }
          
          .info {
        display: flex;
        align-items: center;
       }
   
       .info input, .info select, .info span {
           margin-right: 10px;  /* 각 요소 간 간격 */
       }
   
       .email-input {
           width: 150px;  /* 이메일 주소 입력 크기 조정 */
       }
   
       .box {
           width: 150px;  /* 도메인 입력 및 선택 크기 조정 */
       }
   
       .at-symbol {
           font-size: 16px;
       }
    </style>

    <script>
		$(document).ready(function(){
			
				$("#userNickName").focusout(function(){
				
				//모든 공백 체크 정규식
				var emptCheck = /\s/g;

			
				$("#userNickName").val()
				//닉네임			
				if($.trim($("#userNickName").val()).length <= 0){
					$("#nickNameCheck").css("color", "red");
					$("#nickNameCheck").text("닉네임을 입력해주세요.");
					return;	
				}
				if(emptCheck.test($("#userNickName").val())){
					$("#nickNameCheck").css("color", "red");
					$("#nickNameCheck").text("닉네임에 공백은 포함할 수 없습니다.");
					return;	
				}
				
				if($.trim($("#userNickName").val()).length <= 0){
					$("#nickNameCheck").css("color", "red");
					$("#nickNameCheck").text("사용자 닉네임을 입력하세요.");
					return;
				}
				
				if(emptCheck.test($("#userNickName").val())){
					$("#nickNameCheck").css("color", "orange");
					$("#nickNameCheck").text("사용자 닉네임은 공백을 포함할수 없습니다.");
					return;
				}
				
				$.ajax({
					type:"POST",						
					url:"/user/userNickNameCheckAjax.jsp",
					data:{
						userNickName:$("#userNickName").val()	
					},
					datatype:"JSON",		  			
					success:function(obj){
						var data = JSON.parse(obj);
						
						if(data.flag == 0){
							$("#nickNameCheck").css("color", "green");
							$("#nickNameCheck").text("사용가능한 닉네임 입니다");
							$("#NickNameCheckajax").val("정상");
							
						}else if(data.flag == 1){
							$("#nickNameCheck").css("color", "red");
							$("#nickNameCheck").text("중복된 닉네임이 있습니다. 다시 입력하세요.");
							
						}else{
							
							$("#nickNameCheck").text("닉네임 값을 확인하세요.");
							
						}
					},
					error:function(xhr, status, error){
						$("#nickNameCheck").text("닉네임 중복 체크 오류");
					}
				});

			});

			
			$("#btnUpdate").on("click", function(){
				
				//아이디, 비밀번호 정규표현식(영문 대소문자, 숫자로만 이루어진 4~12자리 정규식)
				var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
				//모든 공백 체크 정규식
				var emptCheck = /\s/g;
				//연락처 정규식
				var telCheck = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/;   
				
				
				//비밀번호
				if($.trim($("#userPwd1").val()).length <= 0){
					alert("비밀번호를 입력해주세요.");
					$("#userPwd1").val("");
					$("#userPwd1").focus();
					return;
				}
				
				if(emptCheck.test($("#userPwd1").val())){
					alert("비밀번호는 공백을 포함할수 없습니다.");
					$("#userPwd1").val("");
					$("#userPwd1").focus();
					return;
				}
				
				if(!idPwCheck.test($("#userPwd1").val())){
					alert("비밀번호는 4~12자의 영문 대소문자의 숫자로만 입력가능합니다.");
					$("#userPwd1").val("");
					$("#userPwd1").focus();
					return;
				}
				
				//비밀번호 확인
				if($.trim($("#userPwd2").val()).length <= 0){
					alert("비밀번호 확인을 입력해주세요.");
					$("#userPwd2").val("");
					$("#userPwd2").focus();
					return;
				}
				
				if($("#userPwd1").val() != $("#userPwd2").val()){
					alert("비밀번호가 일치하지 않습니다.");
					$("#userPwd2").val("");
					$("#userPwd2").focus();
					return;	
				}
				
				$("#userPwd").val($("#userPwd1").val());
				
				//이름
				
				if($.trim($("#userName").val()).length <= 0){
					alert("이름을 입력해주세요.");
					$("#username").val("");
					$("#username").focus();
					return;	
				}
				
				if(emptCheck.test($("#userName").val())){
					alert("이름에 공백은 포함할 수 없습니다.");
					$("#userName").val("");
					$("#userName").focus();
					return;	
				}			
				
				
				//주소
				if($.trim($("#userAddress").val()).length <= 0){
					alert("주소를 입력해주세요.");
					$("#userAddress").val("");
					$("#userAddress").focus();
					return;	
				}
				
				//연락처
				if($.trim($("#userTel").val()).length <= 0){
					alert("연락처를 입력해주세요.");
					$("#userTel").val("");
					$("#userTel").focus();
					return;	
				}
				
				if(!telCheck.test($("#userTel").val())){
					alert("연락처가 올바르지 않습니다. 다시한번 확인해 주세요.");
					$("#userTel").val("");
					$("#userTel").focus();
					return;	
				}
				
				//이메일
				if($.trim($("#emailInput").val()).length <= 0){
					alert("사용자 이메일을 입력하세요.");
					$("#emailInput").val("");
					$("#emailInput").focus();
					return;
				}
				
				var email = $("#emailInput").val() + '@' + $("#domain-txt").val();
				
				if(!fn_validateEmail(email)){
					alert("사용자 이메일 형식이 올바르지 않습니다. 다시 입력하세요.");
					$("#emailInput").val("");
					$("#emailInput").focus();
					return;
				}
				
				$("#email").val(email);
				document.updateForm.submit();
				
				
			});	
			
		});
		
		function fn_validateEmail(value)
		{
		   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		   
		   return emailReg.test(value);
		}
	</script>
    

</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
    <!-- 왼쪽 메뉴 리스트 -->
    <div class="menu">
        <ul>
            <li><a href="/user/userUpdateForm.jsp">정보 수정</a></li>
            <li><a href="/user/userDeleteForm.jsp">회원탈퇴</a></li>
        </ul>
    </div>

    <!-- 오른쪽 컨텐츠 영역 -->
    <div class="content">
        <!-- 사용자 정보 섹션 -->
        <div class="user-info">
            <img src="https://via.placeholder.com/60" alt="사용자 이미지">
            <div>
                <h2><%= user.getUser_name() %>님 안녕하세요.</h2>
                <p>누적 구매금액: 0원</p>
            </div>
        </div>

        <!-- 회원 정보 수정 폼 섹션 -->
        <div class="user-form">
            <h3>회원 정보 수정</h3>
            <form name="updateForm" id="updateForm" action="/user/userUpdateProc.jsp" method="post">
               <label for="userId">아이디</label>
               <input type="text" id="userId" name="userId" value="<%= user.getUser_id() %>" readonly>
               
               <label for="userPwd1">비밀번호</label>
               <input type="password" id="userPwd1" name="userPwd1" value="<%= user.getUser_pwd() %>">
               
               <label for="userPwd2">비밀번호 확인</label>
               <input type="password" id="userPwd2" name="userPwd2" value="<%= user.getUser_pwd() %>">
            
                <label for="username">이름</label>
                <input type="text" id="userName" name="userName" value="<%= user.getUser_name() %>">
                <label for="userNickname">닉네임</label>
                <input type="text" id="userNickName" name="userNickName" value="<%= user.getUser_nickname() %>">
                <p id="nickNameCheck"></p>
                
                <label for="userGender">성별</label>
                <select id="userGender" name="userGender" required>
                   <option value="male" 
                   <% if (StringUtil.equals(user.getUser_gender(), "남")) { %> 
                   selected <% } %>>남성</option>
                   <option value="female" 
                   <% if (StringUtil.equals(user.getUser_gender(), "여")) { %> 
                   selected <% } %>>여성</option>
                  </select>
                  
                  <label for="userAddress">주소</label>
                  <input type="text" id="userAddress" name="userAddress" value="<%= user.getUser_address() %>">
                  
                  <label for="userTel">연락처</label>
                  <input type="text" id="userTel" name="userTel" value="<%= user.getUser_tel() %>">

                <label for="email">이메일</label>
            <div class="info">
                <input type="text" id="emailInput" class="email-input" placeholder="이메일 주소" size="10" value="">
                <span class="at-symbol">@</span>
                <input class="box" id="domain-txt" type="text" size="10">
                <select class="box" id="domain-list">
                    <option value="type">직접 입력</option>
                    <option value="naver.com">naver.com</option>
                    <option value="google.com">google.com</option>
                    <option value="hanmail.net">hanmail.net</option>
                    <option value="nate.com">nate.com</option>
                    <option value="kakao.com">kakao.com</option>
                </select>
            </div>

				<input type="hidden" id="email" name="email" value="">
                <input type="hidden" id="userPwd" name="userPwd" value="">
                <button type="button" name="btnUpdate" id="btnUpdate">정보 수정</button>
            </form>
        </div>
    </div>
</div>

<script>

    // ----- 이메일 처리 ------
   const email = "<%= user.getUser_email() %>";
   const emailArr = email.split("@");
   
   console.log(emailArr[0]);
   console.log(emailArr[1]); 
   
   // 이메일 앞부분 설정
    document.getElementById("emailInput").value = emailArr[0];
   document.getElementById("domain-txt").value = emailArr[1];

    // 도메인 설정 및 도메인 자동 선택
    const domainList = document.getElementById("domain-list");
    const domainTxt = document.getElementById("domain-txt");

    let isDomainMatched = false;

    for (let i = 0; i < domainList.options.length; i++) {
        if (domainList.options[i].value == emailArr[1]) {
            domainList.selectedIndex = i;
            isDomainMatched = true;
            break;
        }
    }

    // 도메인 선택 변경 시 직접 입력 처리
    domainList.addEventListener("change", function() {
        if (domainList.value === "type") {
            domainTxt.style.display = 'inline-block';
            domainTxt.value = "";
        } else {
            domainTxt.value = domainList.value;
        }
    });
   
   
   // 기존 부분
   const domainListEl = document.querySelector('#domain-list');
   const domainInputEl = document.querySelector('#domain-txt');

   // select 옵션 변경 시
   domainListEl.addEventListener('change', (event) => {
     // option에 있는 도메인 선택 시
     if(event.target.value !== "type") {
       // 선택한 도메인을 input에 입력하고 disabled
       domainInputEl.value = event.target.value
       domainInputEl.disabled = true;
     } else { // 직접 입력 시
       // input 내용 초기화 & 입력 가능하도록 변경
       domainInputEl.value = "";
       domainInputEl.disabled = false;
     }
   })
</script>

</body>
</html>


<%
   }
%>
