<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%

	Logger logger = LogManager.getLogger("userNickNameCheckAjax.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userNickName = HttpUtil.get(request, "userNickName");
	
	
	if(!StringUtil.isEmpty(userNickName)){
		
		UserDao userDao = new UserDao();
		if(userDao.userNickNameSelectCount(userNickName) <= 0){
			
			//닉네임 미존재(사용가능)
			response.getWriter().write("{\"flag\":0}");
		
		}else{
		
			//중복 닉네임 존재.
			response.getWriter().write("{\"flag\":1}");
		
		}
		
	}else{
		
		//닉네임 값을 전달 받지 못했을 경우.({"flag":-1})
		response.getWriter().write("{\"flag\":-1}");
		
	}
	
%>	