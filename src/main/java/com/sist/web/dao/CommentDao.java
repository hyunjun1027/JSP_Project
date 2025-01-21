package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.Comment;


public class CommentDao {
	
	private static Logger logger = LogManager.getLogger(CommentDao.class);

	//댓글 리스트
	public List<Comment> commentList(long boardSeq){
		
		List<Comment> list = new ArrayList<Comment>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COMM_SEQ, ");
		sql.append("NVL(BOARD_SEQ, '') BOARD_SEQ, ");
		sql.append("A.USER_ID USER_ID, ");
		sql.append("B.USER_NICKNAME USER_NICKNAME, ");
		sql.append("NVL(COMM_CONTENT, '') COMM_CONTENT, ");
		sql.append("NVL(TO_CHAR(COMM_REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_REG_DATE, ");
		sql.append("NVL(TO_CHAR(COMM_MODI_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_MODI_DATE, ");
		sql.append("NVL(TO_CHAR(COMM_DEL_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_DEL_DATE ");
		sql.append("FROM TR_COMMENT A, TR_USER B ");
		sql.append("WHERE A.USER_ID = B.USER_ID ");
		sql.append("  AND BOARD_SEQ = ? ");
		sql.append("ORDER BY COMM_MODI_DATE DESC ");
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardSeq);

			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				Comment comment = new Comment();
				
				comment.setComm_seq(rs.getLong("COMM_SEQ"));
				comment.setBoard_seq(rs.getLong("BOARD_SEQ"));
				comment.setUser_id(rs.getString("USER_ID"));
				comment.setUser_nicname(rs.getString("USER_NICKNAME"));
				comment.setComm_content(rs.getString("COMM_CONTENT"));
				comment.setComm_reg_date(rs.getString("COMM_REG_DATE"));
				comment.setComm_modi_date(rs.getString("COMM_MODI_DATE"));
				comment.setComm_del_date(rs.getString("COMM_DEL_DATE"));
				
				list.add(comment);
				
			}
			
		}catch(Exception e) {
			logger.error("[commentDao]commentList SQLExcption", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return list;
		
	}
	
	//댓글 시퀀스 조회
	public long newCommentSeq(Connection conn) {
		
		long commSeq = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT SEQ_TR_COMM_SEQ.NEXTVAL ");
		sql.append("  FROM DUAL ");
		
		try {
			
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {				
				commSeq = rs.getLong(1);				
			}		
			
		}catch(Exception e){
			logger.error("[commentDao]newCommentSeq SQLException", e);
		}finally {
			DBManager.close(rs, pstmt);
		}		
		return commSeq;
	}
	
	//댓글 1개 조회
	public Comment commentSelect(long boardSeq, long commSeq, String userid) {

	    Comment comment = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    StringBuilder sql = new StringBuilder();

	    sql.append("SELECT COMM_SEQ, ");
	    sql.append("       NVL(BOARD_SEQ, '') BOARD_SEQ, ");
	    sql.append("       A.USER_ID USER_ID, ");
	    sql.append("       NVL(B.USER_NICKNAME, '') USER_NICKNAME, ");  // USER_NICKNAME 추가
	    sql.append("       NVL(COMM_CONTENT, '') COMM_CONTENT, ");
	    sql.append("       NVL(TO_CHAR(COMM_REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_REG_DATE, ");
	    sql.append("       NVL(TO_CHAR(COMM_MODI_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_MODI_DATE, ");
	    sql.append("       NVL(TO_CHAR(COMM_DEL_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS COMM_DEL_DATE ");
	    sql.append("  FROM TR_COMMENT A, TR_USER B ");
	    sql.append(" WHERE A.USER_ID = B.USER_ID ");
	    sql.append("   AND BOARD_SEQ = ? ");
	    sql.append("   AND COMM_SEQ = ? ");
	    sql.append("   AND A.USER_ID = ? ");

	    try {

	        conn = DBManager.getConnection();
	        pstmt = conn.prepareStatement(sql.toString());

	        pstmt.setLong(1, boardSeq);
	        pstmt.setLong(2, commSeq);
	        pstmt.setString(3, userid);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {

	            comment = new Comment();

	            comment.setComm_seq(rs.getLong("COMM_SEQ"));
	            comment.setBoard_seq(rs.getLong("BOARD_SEQ"));
	            comment.setUser_id(rs.getString("USER_ID"));
	            comment.setUser_nicname(rs.getString("USER_NICKNAME"));  // USER_NICKNAME 설정
	            comment.setComm_content(rs.getString("COMM_CONTENT"));
	            comment.setComm_reg_date(rs.getString("COMM_REG_DATE"));
	            comment.setComm_modi_date(rs.getString("COMM_MODI_DATE"));
	            comment.setComm_del_date(rs.getString("COMM_DEL_DATE"));

	        }

	    } catch (Exception e) {
	        logger.error("[BoardDao]commentSelect SQLExcption", e);
	    } finally {
	        DBManager.close(rs, pstmt, conn);
	    }

	    return comment;

	}


	
	//댓글 등록
	public int commentInsert(Comment comment) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO TR_COMMENT ");
		sql.append("(COMM_SEQ, BOARD_SEQ, USER_ID, COMM_CONTENT, COMM_REG_DATE, COMM_MODI_DATE) ");
		sql.append("VALUES ");
		sql.append("(?, ?, ?, ?, SYSDATE, SYSDATE) ");
					
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			long commSeq = newCommentSeq(conn);
			comment.setComm_seq(commSeq);
			
			logger.debug("getComm_seq" + comment.getComm_seq());
			logger.debug("getComm_seq" + comment.getBoard_seq());
			logger.debug("getComm_seq" + comment.getUser_id());
			logger.debug("getComm_seq" + comment.getComm_content());
			
			pstmt.setLong(++idx, comment.getComm_seq());
			pstmt.setLong(++idx, comment.getBoard_seq());
			pstmt.setString(++idx, comment.getUser_id());
			pstmt.setString(++idx, comment.getComm_content());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[commentDao]commentInsert SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
		
	}
	
	//댓글 수정
	public int commentUpdate(Comment comment) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_COMMENT ");
		sql.append("   SET COMM_CONTENT = ? ");
		sql.append(" WHERE COMM_SEQ = ? ");
		sql.append("   AND BOARD_SEQ = ? ");
		sql.append("   AND USER_ID = ? ");
				
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, comment.getComm_content());
			pstmt.setLong(++idx, comment.getComm_seq());
			pstmt.setLong(++idx, comment.getBoard_seq());
			pstmt.setString(++idx, comment.getUser_id());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[commentDao]commentUpdate SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		return count;
		
	}

	//댓글 삭제	
	public int commentDelete(Comment comment) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM TR_COMMENT ");
		sql.append(" WHERE COMM_SEQ = ? ");
		sql.append("   AND BOARD_SEQ = ? ");
		sql.append("   AND USER_ID = ? ");
		
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(++idx, comment.getComm_seq());
			pstmt.setLong(++idx, comment.getBoard_seq());
			pstmt.setString(++idx, comment.getUser_id());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[commentDao]commentDelete SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}

		return count;
		
	}
	
	
	
}
