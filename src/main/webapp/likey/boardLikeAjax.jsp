<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.dao.LikeyDao"%>
<%@ page import="com.sist.web.model.Likey"%>

<%

	Logger logger = LogManager.getLogger("/baord/boardLikeAjax.jsp");
	HttpUtil.requestLogString(request, logger);

	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	int likeCheck = HttpUtil.get(request, "likeCheck", (int)5);
	
	String userId = HttpUtil.get(request, "userId", "");
	
	logger.debug("userId : " + userId);
	logger.debug("boardSeq : " + boardSeq);
	logger.debug("likeCheck : " + likeCheck);
	
	Likey likey = new Likey();
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(boardSeq) && !StringUtil.isEmpty(likeCheck)){
		
		LikeyDao likeyDao = new LikeyDao();
		BoardDao boardDao = new BoardDao();
		
		likey.setUser_id(userId);
		likey.setBoard_seq(boardSeq);
		
		if(likeCheck == 0){
			 
			if(likeyDao.likeInsert(likey) != 0 && boardDao.boardLikeCntPlus(boardSeq) != 0){
				//증가성공
				response.getWriter().write("{\"flag\":0}");
				
			}else{
				//증가실패
				response.getWriter().write("{\"flag\":1}");

			}
			
		}else{
			
			if(likeyDao.likeDelete(likey) != 0 && boardDao.boardLikeCntMinus(boardSeq) != 0){
				//감소성공
				response.getWriter().write("{\"flag\":2}");
			}else{
				//감소실패
				response.getWriter().write("{\"flag\":3}");
			}
		}
	}
	
	
	

%>

