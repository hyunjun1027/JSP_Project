<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%

	Logger logger = LogManager.getLogger("userIdCheckAjax.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	
	if(!StringUtil.isEmpty(userId)){
		
		UserDao userDao = new UserDao();
		if(userDao.userIdSelectCount(userId) <= 0){
			
			//아이디 미존재(사용가능)
			response.getWriter().write("{\"flag\":0}");
		
		}else{
		
			//중복 아이디 존재.
			response.getWriter().write("{\"flag\":1}");
		
		}
		
	}else{
		
		//아이디 값을 전달 받지 못했을 경우.({"flag":-1})
		response.getWriter().write("{\"flag\":-1}");
		
	}
	

	
%>
