<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.dao.UserDao"%>
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
	
    UserDao userDao = new UserDao();
    user = userDao.userSelect(cookieUserId);
    
    if(!StringUtil.isEmpty(cookieUserId)){
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/include/head.jsp" %>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 정보 페이지</title>
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
        .order-status {
            background-color: #f9f9f9;
            padding: 20px;
            text-align: center;
            border-radius: 5px;
        }
        .order-status p {
            color: #888;
            font-size: 14px;
        }

    </style>

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