<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/include/head.jsp" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
	
	<style>
	   /* Basic Reset */
	* {
	    margin: 0;
	    padding: 0;
	    box-sizing: border-box;
	}
	
	body {
	    font-family: Arial, sans-serif;
	    background-color: #f4f4f4;
	    color: #333;
	}
	
	/* Signup Section */
	.signup-container {
	    max-width: 600px;
	    margin: 50px auto;
	    background-color: white;
	    padding: 20px;
	    border-radius: 10px;
	    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
	}
	
	.signup-container h2 {
	    text-align: center;
	    color: #00a884;
	    margin-bottom: 20px;
	}
	
	.signup-container form {
	    display: flex;
	    flex-direction: column;
	}
	
	.signup-container label {
	    margin-bottom: 5px;
	    font-weight: bold;
	}
	
	.signup-container input, .signup-container select {
	    padding: 10px;
	    margin-bottom: 15px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    font-size: 1em;
	}
	
	.input-group {
	    display: flex;
	    align-items: center;
	}
	
	.input-group input {
	    flex: 1; /* input이 가능한 공간을 모두 차지하도록 설정 */
	}
	#idCheck {
		padding-bottom: 15px;
	}
	
	#btnIdChk {
	    background-color: #00a884;
	    color: white;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	    font-size: 1.0em; /* 버튼 글씨 크기 */
	    margin-left: 10px; /* 버튼과 입력 필드 사이의 간격 */
	}
	
	.signup-container button {
	    background-color: #00a884;
	    color: white;
	    padding: 10px;
	    border: none;
	    cursor: pointer;
	    font-size: 1.2em;
	}
	
	.signup-container button:hover {
	    background-color: #007e6b;
	}
	
	select.box {
	  width: 45%;
	  height: 40px;
	  box-sizing: border-box;
	  margin-left: 5px;
	  padding: 5px 0 5px 10px;
	  border-radius: 4px;
	  border: 1px solid #d9d6d6;
	  color: #383838;
	  background-color: #ffffff;
	  font-family: 'Montserrat', 'Pretendard', sans-serif;
	}
	
	option {
	  font-size: 16px;
	}
	
	.info .box #domain-list option {
	  font-size: 14px;
	  background-color: #ffffff;
	}
	
	</style>
	
	<script>
		$(document).ready(function(){
			
			$("#userId").focus();
			
			$("#userId").focusout(function(){
				//아이디, 비밀번호 정규표현식(영문 대소문자, 숫자로만 이루어진 4~12자리 정규식)
				var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
				//모든 공백 체크 정규식
				var emptCheck = /\s/g;
				
				if($.trim($("#userId").val()).length <= 0){
					$("#idCheck").css("color", "red");
					$("#idCheck").text("사용자 아이디를 입력하세요.");
					return;
				}
				
				if(emptCheck.test($("#userId").val())){
					$("#idCheck").css("color", "orange");
					$("#idCheck").text("사용자 아이디는 공백을 포함할수 없습니다.");
					return;
				}
				
				if(!idPwCheck.test($("#userId").val())){
					$("#idCheck").css("color", "red");
					$("#idCheck").text("사용자 아이디는 4~12자의 영문 대소문자의 숫자로만 입력가능합니다.");
					return;
				}
				
				$.ajax({
					type:"POST",						
					url:"/user/userIdCheckAjax.jsp",
					data:{
						userId:$("#userId").val()	
					},
					datatype:"JSON",		  			
					success:function(obj){
						var data = JSON.parse(obj);
						
						if(data.flag == 0){
							$("#idCheck").css("color", "green");
							$("#idCheck").text("사용가능한 아이디 입니다");
							$("#idCheckajax").val("정상");
							
						}else if(data.flag == 1){
							$("#idCheck").css("color", "red");
							$("#idCheck").text("중복된 아이디가 있습니다. 다시 입력하세요.");
							
						}else{
							
							$("#idCheck").text("아이디 값을 확인하세요.");
							
						}
					},
					error:function(xhr, status, error){
						$("#idCheck").text("아이디 중복 체크 오류");
					}
				});

			});
			
			
			$("#userNickName").focusout(function(){
				
				//모든 공백 체크 정규식
				var emptCheck = /\s/g;
				
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
			
			$("#regBtn").on("click", function(){
				
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
				if($.trim($("#pwdChk").val()).length <= 0){
					alert("비밀번호 확인을 입력해주세요.");
					$("#pwdChk").val("");
					$("#pwdChk").focus();
					return;
				}
				
				if($("#userPwd1").val() != $("#pwdChk").val()){
					alert("비밀번호가 일치하지 않습니다.");
					$("#pwdChk").val("");
					$("#pwdChk").focus();
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
				if($.trim($("#userPhone").val()).length <= 0){
					alert("연락처를 입력해주세요.");
					$("#userPhone").val("");
					$("#userPhone").focus();
					return;	
				}
				
				if(!telCheck.test($("#userPhone").val())){
					alert("연락처가 올바르지 않습니다. 다시한번 확인해 주세요.");
					$("#userPhone").val("");
					$("#userPhone").focus();
					return;	
				}
				
				//이메일
				if($.trim($("#userEmail").val()).length <= 0){
					alert("사용자 이메일을 입력하세요.");
					$("#userEmail").val("");
					$("#userEmail").focus();
					return;
				}
				
				var email = $("#userEmail").val() + '@' + $("#domain-txt").val();
				
				if(!fn_validateEmail(email)){
					alert("사용자 이메일 형식이 올바르지 않습니다. 다시 입력하세요.");
					$("#userEmail").val("");
					$("#userEmail").focus();
					return;
				}
				
				$("#email").val(email);
				
				if($("#idCheckajax").val() == "정상"){
					document.regForm.submit();
				}else{
					alert("아이디를 확인해 주세요.");
				}
				
				if($("#NickNameCheckajax").val() == "정상"){
					document.regForm.submit();
				}else{
					alert("닉네임을 확인해 주세요.");
				}
				
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
    <!-- Header -->
    <%@ include file="/include/navigation.jsp" %>

    <!-- Signup Section -->
    <div class="signup-container">
        <h2>회원가입</h2>
        <form id="regForm" name="regForm" method="post" action="/user/userRegProc.jsp">
            <label for="userId">아이디</label>
            <div class="input-group">
                <input type="text" id="userId" name="userId" placeholder="아이디를 입력해주세요." required>
                <!-- <button type="button" id="btnIdChk">중복 확인</button> -->
            </div>
			<p id="idCheck"></p>
			
            <label for="userPwd">비밀번호</label>
            <input type="password" id="userPwd1" name="userPwd1" placeholder="비밀번호를 입력해주세요." required>

            <label for="pwdChk">비밀번호 확인</label>
            <input type="password" id="pwdChk" name="pwdChk" placeholder="비밀번호를 다시 입력해주세요." required>

            <label for=userName>이름</label>
            <input type="text" id="userName" name="userName" placeholder="이름을 입력해주세요." required>
            
            <label for="userNickName">닉네임</label>
            <input type="text" id="userNickName" name="userNickName" placeholder="닉네임을 입력해주세요." required>
            <p id="nickNameCheck"></p>
            
            <label for="userGender">성별</label>
            <select id="userGender" name="userGender" required>
                <option value="male">남성</option>
                <option value="female">여성</option>
            </select>

            <label for="userAddress">주소</label>
            <input type="text" id="userAddress" name="userAddress" placeholder="주소를 입력해주세요." required>

            <label for="userPhone">연락처</label>
            <input type="tel" id="userPhone" name="userPhone" placeholder="연락처를 입력해주세요. ('-' 제외 11자리 입력)" required>

         <label for="email">이메일</label>
              <div class="info">
                 <input type="text" class="email-input" id="userEmail" placeholder="이메일 주소" size="10" required>
                 <span class="at-symbol">@</span>
                 <input class="box" id="domain-txt" type="text" size="10"/>
                  <select class="box" id="domain-list">
                       <option value="type">직접 입력</option>
                       <option value="naver.com">naver.com</option>
                       <option value="google.com">google.com</option>
                       <option value="hanmail.net">hanmail.net</option>
                       <option value="nate.com">nate.com</option>
                       <option value="kakao.com">kakao.com</option>
                  </select>
             </div>
             <input type="hidden" id="idCheckajax" name="idCheckajax" value="">
             <input type="hidden" id="NickNameCheckajax" name="NickNameCheckajax" value="">
             <input type="hidden" id="email" name="email" value="">
             <input type="hidden" id="userPwd" name="userPwd" value="">
			 <button type="submit" id="regBtn">회원가입</button>
		 </form>
	 </div>

<script>
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
