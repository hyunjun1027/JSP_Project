package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;
import com.sist.web.model.Board;

public class BoardDao {
	
	private static Logger logger = LogManager.getLogger(BoardDao.class);
	
	//게시물 리스트 조회
	public List<Board> boardList(Board search, String sortType){
		
		List<Board> list = new ArrayList<Board>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BOARD_SEQ, ");
		sql.append("       USER_ID, ");
		sql.append("	   USER_NICKNAME, ");
		sql.append("	   BOARD_TITLE, ");
		sql.append("	   BOARD_CONTENT, ");
		sql.append("	   BOARD_CATEGORY, ");
		sql.append("	   BOARD_READ_CNT, ");
		sql.append("	   BOARD_LIKE_CNT, ");
		sql.append("	   BOARD_COMMENT_CNT, ");
		sql.append("	   BOARD_REG_DATE, ");
		sql.append("	   BOARD_MODI_DATE, ");
		sql.append("	   BOARD_DEL_DATE ");
		sql.append("  FROM (SELECT ROWNUM AS RNUM, ");
		sql.append("			   BOARD_SEQ, ");
		sql.append("			   USER_ID, ");
		sql.append("			   USER_NICKNAME, ");
		sql.append("			   BOARD_TITLE, ");
		sql.append("			   BOARD_CONTENT, ");
		sql.append("			   BOARD_CATEGORY, ");
		sql.append("			   BOARD_READ_CNT, ");
		sql.append("			   BOARD_LIKE_CNT, ");
		sql.append("			   BOARD_COMMENT_CNT, ");   
		sql.append("			   BOARD_REG_DATE, ");   
		sql.append("			   BOARD_MODI_DATE, ");   
		sql.append("			   BOARD_DEL_DATE ");   
		sql.append("		  FROM (SELECT BOARD_SEQ, ");   
		sql.append("					   A.USER_ID USER_ID, ");   
		sql.append("					   NVL(B.USER_NICKNAME, '') USER_NICKNAME, ");   
		sql.append("					   NVL(A.BOARD_TITLE, '') BOARD_TITLE, ");   
		sql.append("					   NVL(A.BOARD_CONTENT, '') BOARD_CONTENT, ");   
		sql.append("					   NVL(BOARD_CATEGORY, '') BOARD_CATEGORY, ");   
		sql.append("					   NVL(BOARD_READ_CNT, '') BOARD_READ_CNT, ");   
		sql.append("					   NVL(BOARD_LIKE_CNT, '') BOARD_LIKE_CNT, ");   
		sql.append("					   NVL(BOARD_COMMENT_CNT, '') BOARD_COMMENT_CNT, ");   
		sql.append("					   NVL(TO_CHAR(BOARD_REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_REG_DATE, ");   
		sql.append("					   NVL(TO_CHAR(BOARD_MODI_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_MODI_DATE, ");   
		sql.append("					   NVL(TO_CHAR(BOARD_DEL_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_DEL_DATE ");   
		sql.append("				  FROM TR_BOARD A, TR_USER B ");   
		sql.append("				 WHERE A.USER_ID = B.USER_ID ");   
		
		if(search != null) {
			
			if(!StringUtil.isEmpty(search.getUser_nickname())) {
				sql.append("		   AND LOWER(B.USER_NICKNAME) LIKE '%' || LOWER(?) || '%' ");
			}
			
			if(!StringUtil.isEmpty(search.getBoard_title())) {
				sql.append("		   AND LOWER(A.BOARD_TITLE) LIKE '%' || LOWER(?) || '%' "); 
			}
			
			if(!StringUtil.isEmpty(search.getBoard_content())) {
				sql.append("		   AND DBMS_LOB.INSTR(LOWER(A.BOARD_CONTENT), LOWER(?)) > 0 "); 
			}
			
		}
		
		if(StringUtil.equals(sortType, "")) {
			sql.append("				 ORDER BY A.BOARD_SEQ DESC)) "); 
		}
		if(StringUtil.equals(sortType, "1")) {
			sql.append("				 ORDER BY A.BOARD_MODI_DATE DESC)) "); 
		}
		if(StringUtil.equals(sortType, "2")) {
			sql.append("				 ORDER BY A.BOARD_MODI_DATE ASC)) "); 
		}
		if(StringUtil.equals(sortType, "3")) {
			sql.append("				 ORDER BY BOARD_READ_CNT DESC)) "); 
		}
		if(StringUtil.equals(sortType, "4")) {
			sql.append("				 ORDER BY BOARD_LIKE_CNT DESC)) "); 
		}
		if(StringUtil.equals(sortType, "5")) {
			sql.append("				 ORDER BY BOARD_COMMENT_CNT DESC)) "); 
		}


		
		if(search != null) {
			sql.append("WHERE RNUM >= ? ");   
			sql.append("  AND RNUM <= ? ");   
		}

		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(search != null) {
				
				if(!StringUtil.isEmpty(search.getUser_nickname())) {					
					pstmt.setString(++idx, search.getUser_nickname());
				}
				
				if(!StringUtil.isEmpty(search.getBoard_title())) {
					pstmt.setString(++idx, search.getBoard_title());
				}
				
				if(!StringUtil.isEmpty(search.getBoard_content())) {
					pstmt.setString(++idx, search.getBoard_content());
					
				}
				
				pstmt.setLong(++idx, search.getStartRow());
				pstmt.setLong(++idx, search.getEndRow());
				
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				Board board = new Board();
				
				board.setBoard_seq(rs.getLong("BOARD_SEQ"));
				board.setUser_id(rs.getString("USER_ID"));
				board.setUser_nickname(rs.getString("USER_NICKNAME"));
				board.setBoard_title(rs.getString("BOARD_TITLE"));
				board.setBoard_content(rs.getString("BOARD_CONTENT"));
				board.setBoard_category(rs.getString("BOARD_CATEGORY"));
				board.setBoard_read_cnt(rs.getInt("BOARD_READ_CNT"));
				board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
				board.setBoard_comment_cnt(rs.getInt("BOARD_COMMENT_CNT"));
				board.setBoard_reg_date(rs.getString("BOARD_REG_DATE"));
				board.setBoard_modi_date(rs.getString("BOARD_MODI_DATE"));
				board.setBoard_del_date(rs.getString("BOARD_DEL_DATE"));
				
				list.add(board);
				
			}
			
			
		}catch(Exception e){
			logger.error("[BoardDao]boardList SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return list;

	}
	
	//시퀀스 조회 메서드
	public long newBoardSeq(Connection conn) {
		
		long boardSeq = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT SEQ_TR_BOARD_SEQ.NEXTVAL ");
		sql.append("  FROM DUAL ");
		
		try {
			
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {				
				boardSeq = rs.getLong(1);				
			}		
			
		}catch(Exception e){
			logger.error("[BoardDao]newBoardSeq SQLException", e);
		}finally {
			DBManager.close(rs, pstmt);
		}		
		return boardSeq;
	}
	
	//게시물 등록
	public int boardInsert(Board board) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO TR_BOARD ");
		sql.append("(BOARD_SEQ, USER_ID, BOARD_TITLE, BOARD_CONTENT, BOARD_CATEGORY, BOARD_READ_CNT, ");
		sql.append(" BOARD_LIKE_CNT, BOARD_COMMENT_CNT, BOARD_REG_DATE, BOARD_MODI_DATE) ");
		sql.append("VALUES ");
		sql.append("(?, ?, ?, ?, ?, 0, 0, 0, SYSDATE, SYSDATE) ");
		
	    try {
	    	
	    	int idx = 0;
	    	conn = DBManager.getConnection();
	    	
			long boardSeq = newBoardSeq(conn);
			board.setBoard_seq(boardSeq);
	    	
	    	pstmt = conn.prepareStatement(sql.toString());
	    	
	    	pstmt.setLong(++idx, board.getBoard_seq());
	    	pstmt.setString(++idx, board.getUser_id());
	    	pstmt.setString(++idx, board.getBoard_title());
	    	pstmt.setString(++idx, board.getBoard_content());
	    	pstmt.setString(++idx, board.getBoard_category());
	    	
	    	count = pstmt.executeUpdate();
	    	
	    }catch(Exception e){
			logger.error("[BoardDao]boardInsert SQLException", e);
		}finally {
			DBManager.close(pstmt, conn);
		}	
		return count;
		
	}
	
	//총 게시물 수 조회
	public long boardTotalCount(Board search) {
		
		long totalcount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(BOARD_SEQ) CNT ");				
		sql.append("  FROM TR_BOARD A, TR_USER B ");
		sql.append(" WHERE A.USER_ID = B.USER_ID ");
		
		if(search != null) {
			
			if(!StringUtil.isEmpty(search.getUser_nickname())) {
				sql.append("		   AND LOWER(B.USER_NICKNAME) LIKE '%' || LOWER(?) || '%' ");
			}
			
			if(!StringUtil.isEmpty(search.getBoard_title())) {
				sql.append("		   AND LOWER(A.BOARD_TITLE) LIKE '%' || LOWER(?) || '%' "); 
			}
			
			if(!StringUtil.isEmpty(search.getBoard_content())) {
				sql.append("		   AND DBMS_LOB.INSTR(LOWER(A.BOARD_CONTENT), LOWER(?)) > 0 "); 
			}
			
		}


		try {
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(search != null) {
				
				if(!StringUtil.isEmpty(search.getUser_nickname())) {					
					pstmt.setString(++idx, search.getUser_nickname());
				}
				
				if(!StringUtil.isEmpty(search.getBoard_title())) {
					pstmt.setString(++idx, search.getBoard_title());
				}
				
				if(!StringUtil.isEmpty(search.getBoard_content())) {
					pstmt.setString(++idx, search.getBoard_content());
					
				}
				
			}
			logger.debug(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				totalcount = rs.getLong("CNT");
			}
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardTotalCount SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return totalcount;
	}
	
	//총 댓글 수 조회
	public long commentTotalCount(long boardSeq) {
		
		long commtotalcount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(COMM_SEQ) CNT ");				
		sql.append("  FROM TR_BOARD A, TR_COMMENT B ");
		sql.append(" WHERE A.BOARD_SEQ = B.BOARD_SEQ ");
		sql.append("   AND B.BOARD_SEQ = ? ");

		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			pstmt.setLong(1, boardSeq);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				commtotalcount = rs.getLong("CNT");
			}
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardTotalCount SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return commtotalcount;
	}
	
	//게시물 조회(1건)
	public Board boardSelect(long boardSeq) {
		
		Board board = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT A.BOARD_SEQ BOARD_SEQ, ");   
		sql.append("	   B.USER_ID USER_ID, ");   
		sql.append("	   NVL(B.USER_NICKNAME, '') USER_NICKNAME, ");   
		sql.append("	   NVL(A.BOARD_TITLE, '') BOARD_TITLE, ");   
		sql.append("	   NVL(A.BOARD_CONTENT, '') BOARD_CONTENT, ");   
		sql.append("	   NVL(A.BOARD_CATEGORY, '') BOARD_CATEGORY, ");   
		sql.append("	   NVL(A.BOARD_READ_CNT, '') BOARD_READ_CNT, ");   
		sql.append("	   NVL(A.BOARD_LIKE_CNT, '') BOARD_LIKE_CNT, ");   
		sql.append("	   NVL(A.BOARD_COMMENT_CNT, '') BOARD_COMMENT_CNT, ");   
		sql.append("	   NVL(TO_CHAR(A.BOARD_REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_REG_DATE, ");   
		sql.append("	   NVL(TO_CHAR(A.BOARD_MODI_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_MODI_DATE, ");   
		sql.append("	   NVL(TO_CHAR(A.BOARD_DEL_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS BOARD_DEL_DATE ");   
		sql.append("  FROM TR_BOARD A, TR_USER B ");   
		sql.append(" WHERE A.BOARD_SEQ = ? ");   
		sql.append("   AND A.USER_ID = B.USER_ID ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
	
			pstmt.setLong(1, boardSeq);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				board = new Board();
				
				board.setBoard_seq(rs.getLong("BOARD_SEQ"));
				board.setUser_id(rs.getString("USER_ID"));
				board.setUser_nickname(rs.getString("USER_NICKNAME"));
				board.setBoard_title(rs.getString("BOARD_TITLE"));
				board.setBoard_content(rs.getString("BOARD_CONTENT"));
				board.setBoard_category(rs.getString("BOARD_CATEGORY"));
				board.setBoard_read_cnt(rs.getInt("BOARD_READ_CNT"));
				board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
				board.setBoard_comment_cnt(rs.getInt("BOARD_COMMENT_CNT"));
				board.setBoard_reg_date(rs.getString("BOARD_REG_DATE"));
				board.setBoard_modi_date(rs.getString("BOARD_MODI_DATE"));
				board.setBoard_del_date(rs.getString("BOARD_DEL_DATE"));
				
			}
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardSelect SQLExcption", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}

		return board;
		
	}
	
	//게시물 조회수 증가
	public int boardReadCntPlus(long boardSeq) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_READ_CNT = BOARD_READ_CNT + 1 ");
		sql.append(" WHERE BOARD_SEQ = ? ");
		
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardReadCntPlus SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		
		return count;
		
	}

	
	
	
	//게시글 수정
	public int boardUpdate(Board board) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_TITLE = ?, ");
		sql.append("	   BOARD_CONTENT = ? ");
		sql.append(" WHERE BOARD_SEQ = ? ");

		try {
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, board.getBoard_title());
			pstmt.setString(++idx, board.getBoard_content());
			pstmt.setLong(++idx, board.getBoard_seq());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardUpdate SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
		
	}
	
	
	//게시글 삭제
	public int boardDelete(long boardSeq) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM TR_BOARD ");
		sql.append(" WHERE BOARD_SEQ = ? ");
						
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardDelete SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}

		return count;
		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////

	//좋아요수 증가
	public int boardLikeCntPlus(long boardSeq) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_LIKE_CNT = BOARD_LIKE_CNT + 1 ");
		sql.append(" WHERE BOARD_SEQ = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardLikeCntPlus SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	//좋아요수 감소
	public int boardLikeCntMinus(long boardSeq) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_LIKE_CNT = BOARD_LIKE_CNT - 1 ");
		sql.append(" WHERE BOARD_SEQ = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardLikeCntMinus SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	//댓글수 증가
	public int boardCommentCntPlus(long boardSeq) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_COMMENT_CNT = BOARD_COMMENT_CNT + 1 ");
		sql.append(" WHERE BOARD_SEQ = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardLikeCntPlus SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	//댓글수 감소
	public int boardCommentCntMinus(long boardSeq) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_BOARD ");
		sql.append("   SET BOARD_COMMENT_CNT = BOARD_COMMENT_CNT - 1 ");
		sql.append(" WHERE BOARD_SEQ = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]boardLikeCntMinus SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
		
	
	
	
	
	
}
