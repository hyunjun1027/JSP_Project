<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<%
	Logger logger = LogManager.getLogger("userProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String userName = HttpUtil.get(request, "userName");
	String userNickName = HttpUtil.get(request, "userNickName");
	String userGender = HttpUtil.get(request, "userGender");
	String userAddress = HttpUtil.get(request, "userAddress");
	String userPhone = HttpUtil.get(request, "userPhone");
	String userEmail = HttpUtil.get(request, "email");
	
	String msg = "";
	String redirectUrl = "";
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao();
	
	if(StringUtil.isEmpty(cookieUserId)){
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)
								&& !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userNickName)
								&& !StringUtil.isEmpty(userGender) && !StringUtil.isEmpty(userAddress)
								&& !StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(userEmail)){
			
			if(userDao.userIdSelectCount(userId) > 0){
				
				msg = "아이디가 중복되었습니다. 아이디를 확인해 주세요.";
				redirectUrl = "/user/userRegForm.jsp";
				
			}else{
				User user = new User();
				
				user.setUser_id(userId);
				user.setUser_pwd(userPwd);
				user.setUser_name(userName);
				user.setUser_nickname(userNickName);
				user.setUser_gender(userGender);
				user.setUser_address(userAddress);
				user.setUser_tel(userPhone);
				user.setUser_email(userEmail);
				user.setUser_status("정상");
				
				
				if(userDao.userInsert(user) > 0){
					msg = "회원가입이 완료되었습니다.";
					redirectUrl = "/";
				}else{
					msg = "회원가입 중 오류가 발생하였습니다.";
					redirectUrl = "/user/userRegForm.jsp";
				}
			}

		}else{
			msg = "회원가입 정보가 올바르지 않습니다.";
			redirectUrl = "/user/userRegForm.jsp";
		}
		
	}
	
	
	
	
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
		alert("<%=msg%>");
		location.href = "<%=redirectUrl%>";
	});
</script>
</head>
<body>

</body>
</html>