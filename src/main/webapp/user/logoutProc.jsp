<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.util.CookieUtil"%>

<%
	
	if(CookieUtil.getCookie(request, "USER_ID") != null){
		CookieUtil.deleteCookie(request, response, "/", "USER_ID");
	}
	
	response.sendRedirect("/index.jsp");
	
%>