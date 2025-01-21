<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<%
	Logger logger = LogManager.getLogger("userDeleteProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwdChk");
	
	String msg = "";
	String redirectUrl = "";
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao();
	
	User user = userDao.userSelect(cookieUserId);
	
	if(user != null){
		
		if(StringUtil.equals(user.getUser_status(), "정상")
										&& StringUtil.equals(user.getUser_id(), userId)){
				
			if(userDao.userDelete(user) > 0){
				
				msg = "탈퇴가 완료되었습니다.";
				redirectUrl = "/";
				CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			}
			
		}else{
			
			CookieUtil.deleteCookie(request, response, "", "USER_ID");
			msg = "정지된 사용자 입니다.";
			redirectUrl = "/";
			
		}
		
	}else{
		
		CookieUtil.deleteCookie(request, response, "", "USER_ID");
		msg = "올바른 사용자가 아닙니다.";
		redirectUrl = "/";
		
	}

%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>
</head>
<body>

<script>
	$(document).ready(function(){
		alert("<%=msg%>");
		location.href = "<%=redirectUrl%>";
	});
</script>
</body>
</html>