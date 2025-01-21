<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
	
	Logger logger = LogManager.getLogger("findIdProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String msg = "";
	String redirectUrl = "";
	
	String userName = HttpUtil.get(request, "userName");
	String userEmail = HttpUtil.get(request, "userEmail1");
	
	logger.debug("userName : " + userName);
	logger.debug("userEmail : " + userEmail);
	
	if(!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)){
		User user = new User();
		UserDao userDao = new UserDao();
		
		user = userDao.FindId(userName, userEmail);
		
		if(user != null){
			//성공
			msg = "회원님의 아이디는 : " + user.getUser_id() + " 입니다.";
			redirectUrl = "/index.jsp";
		}else{
			//실패
			msg = "일치하는 회원 정보가 없습니다.";
			redirectUrl = "/user/userFindForm.jsp";
		}
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
	location.href="<%=redirectUrl%>";

</script>
</body>
</html>