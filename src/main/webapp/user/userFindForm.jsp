<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디/비밀번호 찾기</title>
	<%@ include file="/include/head.jsp" %>
    <style>
        /* 스타일을 여기에 직접 작성할 수 있지만, 별도 파일로 분리하는 것이 좋습니다. */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        .content {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 90vh;
        }

        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 350px;
            width: 100%;
            
        }

        h1 {
            margin-bottom: 20px;
            font-size: 24px;
            color: black;
            text-align: center;
        }

        /* 탭 스타일 */
        .tab-menu {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .tab {
            width: 50%;
            padding: 10px;
            background-color: #f4f4f4;
            border: none;
            cursor: pointer;
            font-size: 16px;
            color: #333;
            font-weight: bold;
        }

        .tab.active {
            background-color: #00a884;
            color: #fff;
        }

        /* 폼 스타일 */
        .form-section {
            display: none;
        }

        .form-section.active {
            display: block;
        }

        .form-section input {
            width: 100%;
            padding: 10px;
            margin: 5px 0 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-section button {
            width: 100%;
            padding: 10px;
            background-color: #00a884;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        .form-section label{
        	font-weight: bold;
        }

    </style>
    
    <script>
    	$(document).ready(function(){
    		
			$("#findId-btn").on("click", function(){
				
				if($.trim($("#userName").val()).length <= 0){
					
					alert("이름을 입력하세요.");
					$("#userName").val("");
					$("#userName").focus();
					return;
					
				}
				
				if($.trim($("#userEmail1").val()).length <= 0){
					alert("이메일을 입력하세요.");
					$("#userEmail1").val("");
					$("#userEmail1").focus();
					return;
				}
				
				document.FindIdForm.submit();
				
			});
			
			$("#findPwd-btn").on("click", function(){
				
				if($.trim($("#userId").val()).length <= 0){
					
					alert("아이디를 입력하세요.");
					$("#userId").val("");
					$("#userId").focus();
					return;
					
				}
				
				if($.trim($("#userEmail2").val()).length <= 0){
					alert("이메일을 입력하세요.");
					$("#userEmail2").val("");
					$("#userEmail2").focus();
					return;
				}
				
				document.FindPwdForm.submit();
				
			});
			
    		
    	});
    </script>
    <%
		String cookieUserId = CookieUtil.getValue(request, "USER_ID");
		if(StringUtil.isEmpty(cookieUserId)){
    %>
    
</head>
<body>
	<!-- Header -->
    <%@ include file="/include/navigation.jsp" %>
    <div class="content">
	    <div class="container">
	        <h1>아이디/비밀번호 찾기</h1>

	        <!-- 탭 메뉴 -->
	        <div class="tab-menu">
	            <button id="id-tab" class="tab active">아이디 찾기</button>
	            <button id="pw-tab" class="tab">비밀번호 찾기</button>
	        </div>
	
	        <!-- 아이디 찾기 폼 -->
	        <div id="id-form" class="form-section active">
	            <form id="FindIdForm" name="FindIdForm" action="/user/findIdProc.jsp" method="post">
	            	<label>이름</label>
	                <input type="text" id="userName" name="userName" placeholder="이름을 입력하세요" required>
	            	<label>이메일</label>
	                <input type="text" id="userEmail1" name="userEmail1" placeholder="이메일을 입력하세요" required>
	                <button type="submit" id="findId-btn">아이디 찾기</button>
	            </form>
	        </div>
	
	        <!-- 비밀번호 찾기 폼 -->
	        <div id="pw-form" class="form-section">
	            <form id="FindPwdForm" name="FindPwdForm" action="/user/findPwdProc.jsp" method="post">
	            	<label>아이디</label>
	                <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요" required>
	                <label>이메일</label>
	                <input type="email" id="userEmail2" name="userEmail2" placeholder="이메일을 입력하세요" required>
	                <button type="submit" id="findPwd-btn">비밀번호 찾기</button>
	            </form>
	        </div>
	    </div>
    </div>

    <script>
        // 탭 전환 기능
        const idTab = document.getElementById('id-tab');
        const pwTab = document.getElementById('pw-tab');
        const idForm = document.getElementById('id-form');
        const pwForm = document.getElementById('pw-form');

        idTab.addEventListener('click', () => {
            idForm.classList.add('active');
            pwForm.classList.remove('active');
            idTab.classList.add('active');
            pwTab.classList.remove('active');
        });

        pwTab.addEventListener('click', () => {
            idForm.classList.remove('active');
            pwForm.classList.add('active');
            idTab.classList.remove('active');
            pwTab.classList.add('active');
        });
        
    </script>
</body>
<%
	}else{
%>
		<script>
			alert("로그아웃 이후 이용해주세요.");
			location.href="/";
		</script>
<%
	}
%>
</html>


