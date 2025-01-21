<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<%
	Logger logger = LogManager.getLogger("loginProc.jsp");
	HttpUtil.requestLogString(request, logger);	

	String userId = HttpUtil.get(request, "loginUserId");
	String userPwd = HttpUtil.get(request, "loginUserPwdInput");
	
	String msg = "";
	String redirectUrl = "";
	
	User user = null;
	UserDao userDao = new UserDao();
	
	logger.debug("userId : " + userId);
	logger.debug("userPwd : " + userPwd);
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)){
		
		 user = userDao.userSelect(userId);
		
		if(user != null){
			
			if(StringUtil.equals(userPwd, user.getUser_pwd())){

				if(StringUtil.equals(user.getUser_status(), "정상")){
					
					CookieUtil.addCookie(response, "/", "USER_ID", userId);
					
					msg = "로그인 성공";
					redirectUrl = "/";
					
				}else{
					msg = "탈퇴한 사용자 입니다.";
					redirectUrl = "/";
				}

			}else{
				msg = "비밀번호가 일치하지 않습니다.";
				redirectUrl = "/";
			}
			
		}else{
			msg = "아이디가 존재하지 않습니다.";
			redirectUrl = "/";
		}
	}else{
		
		//아이디나 비밀번호가 입력되지 않은 경우
		msg = "아이디나 비밀번호가 입력되지 않았습니다.";
		redirectUrl = "/";
		
	}
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>

	alert("<%=msg%>");
	location.href = "<%=redirectUrl%>";
	
</script>
</body>
</html>