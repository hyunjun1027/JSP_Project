<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<%
	Logger logger = LogManager.getLogger("userUpdateProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String userName = HttpUtil.get(request, "userName");
	String userNickName = HttpUtil.get(request, "userNickName");
	String userGender = HttpUtil.get(request, "userGender");
	String userAddress = HttpUtil.get(request, "userAddress");
	String userPhone = HttpUtil.get(request, "userTel");
	String userEmail = HttpUtil.get(request, "email");
	
	String msg = "";
	String redirectUrl = "";
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao();
	
	//회원 정보 수정
	User user = userDao.userSelect(cookieUserId);
	if(user != null){
		logger.debug("111" + user.getUser_id());
		logger.debug("222" + userId);
		
		
		if(StringUtil.equals(user.getUser_status(), "정상")
										&& StringUtil.equals(user.getUser_id(), userId)){
			
			logger.debug("111" + userId);
			logger.debug("222" + userPwd);
			logger.debug("333" + userName);
			logger.debug("444" + userNickName);
			logger.debug("555" + userGender);
			logger.debug("666" + userAddress);
			logger.debug("777" + userPhone);
			logger.debug("888" + userEmail);
			

			if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)
					&& !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userNickName) 
					&& !StringUtil.isEmpty(userGender) && !StringUtil.isEmpty(userAddress)
					&& !StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(userEmail)){
			

				if(userDao.userNickNameSelectCount(userNickName) == 0 
								|| StringUtil.equals(userNickName, user.getUser_nickname())){
									
					user.setUser_id(userId);
					user.setUser_pwd(userPwd);
					user.setUser_name(userName);
					user.setUser_nickname(userNickName);
					user.setUser_gender(userGender);
					user.setUser_address(userAddress);
					user.setUser_tel(userPhone);
					user.setUser_email(userEmail);
					
					if(userDao.userUpdate(user) > 0){
						
						msg = "회원정보가 수정 되었습니다.";
						redirectUrl = "/user/userUpdateForm.jsp";
						
					}else{
						
						msg = "회원정보 수정 중 오류가 발생하였습니다.";
						redirectUrl = "/user/userUpdateForm.jsp";
						
					}	

					
				}else{
					
					msg = "닉네임이 중복되었습니다.";
					redirectUrl = "/user/userUpdateForm.jsp";

					
				}		
				
			}else{
				
				msg = "회원정보 중 값이 올바르지 않습니다.";
				redirectUrl = "/user/userUpdateForm.jsp";
				
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
</head>
<body>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
		alert("<%=msg%>");
		location.href = "<%=redirectUrl%>";
	});
</script>
</body>
</html>