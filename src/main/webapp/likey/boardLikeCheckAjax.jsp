<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@page import="com.sist.web.dao.LikeyDao"%>
<%@page import="com.sist.web.model.Likey"%>

<%
	Logger logger = LogManager.getLogger("/board/boardLikeCheckAjax.jsp");
	HttpUtil.requestLogString(request, logger);
	

	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	String userId = HttpUtil.get(request, "userId", "");	
	logger.debug("userId : " + userId);
	logger.debug("boardSeq : " + boardSeq);
	
	Likey likey = new Likey();
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(boardSeq)){
		
		LikeyDao likeyDao = new LikeyDao();
		
		likey.setUser_id(userId);
		likey.setBoard_seq(boardSeq);

		
		if(likeyDao.likeSelect(likey) <= 0){
			
			//가능
			response.getWriter().write("{\"flag\":0}");
		
		}else{
			//불가능
			response.getWriter().write("{\"flag\":1}");
		
		}
	
	}else{
		//오류
		response.getWriter().write("{\"flag\":-1}");
		
	}
	
	
%>
