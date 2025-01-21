<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
	Logger logger = LogManager.getLogger("findPwdProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String msg = "";
	String redirectUrl = "";
	
	String userId = HttpUtil.get(request, "userId");
	String userEmail = HttpUtil.get(request, "userEmail2");
	
	logger.debug("userId : " + userId);
	logger.debug("userEmail : " + userEmail);
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail)){
		User user = new User();
		UserDao userDao = new UserDao();
		
		user = userDao.FindPwd(userId, userEmail);
		
		if(user != null){

			msg = "회원님의 비밀번호는 : " + user.getUser_pwd() + " 입니다.";
			redirectUrl = "/index.jsp";
		}else{

			msg = "일치하는 회원 정보가 없습니다.";
			redirectUrl = "/user/userFindForm.jsp";
		}
		
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>
<script>

	alert("<%=msg%>");
	location.href="<%=redirectUrl%>";

</script>
</body>
</html>