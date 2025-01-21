<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	response.setHeader("Cache-Control","no-store");  //매번서버에 요청
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",(long)0);
	
	if (request.getProtocol().equals("HTTP/1.1")) 
	{
		response.setHeader("Cache-Control", "no-cache");
	}
%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="shortcut icon" href="/resources/images/favicon_1.png" type="image/x-icon">
<link rel="icon" href="/resources/images/favicon_1.png" sizes="16x16" type="image/png">
<link rel="icon" href="/resources/images/favicon_1.png" sizes="32x32" type="image/png">
<link rel="icon" href="/resources/images/favicon_1.png" sizes="96x96" type="image/png">
<link rel="icon" href="/resources/images/favicon_1.png" sizes="192x192" type="image/png">
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>