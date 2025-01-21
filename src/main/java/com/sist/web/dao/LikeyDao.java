package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.Likey;

public class LikeyDao {
	
	private static Logger logger = LogManager.getLogger(LikeyDao.class);
	
	//좋아요 조회
	public int likeSelect(Likey likey) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(USER_ID) CNT ");
		sql.append("FROM TR_LIKEY ");
		sql.append("WHERE USER_ID = ? ");
		sql.append("AND BOARD_SEQ = ? ");
							
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, likey.getUser_id());
			pstmt.setLong(2, likey.getBoard_seq());
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("CNT");
			}
			
			
		}catch(Exception e) {
			logger.error("[BoardDao]likeSelect SQLExcption", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return count;
		
		
	}
		
		
	//좋아요 아이디, 번호 추가
	public int likeInsert(Likey likey) {
		logger.debug(likey.getUser_id());
		logger.debug(likey.getBoard_seq());
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO TR_LIKEY ");
		sql.append("(USER_ID, BOARD_SEQ) ");
		sql.append("VALUES ");
		sql.append("(?, ?) ");
		
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			pstmt.setString(++idx, likey.getUser_id());
			pstmt.setLong(++idx, likey.getBoard_seq());
			
			count = pstmt.executeUpdate();
			
			
		}catch(Exception e) {
			logger.error("[BoardDao]likeInsert SQLExcption", e);
		}finally {
			DBManager.close(pstmt, conn);
		}

		return count;
	}


	//좋아요 아이디, 번호 삭제
	public int likeDelete(Likey likey) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM TR_LIKEY ");
		sql.append("WHERE USER_ID = ? ");
		sql.append("AND BOARD_SEQ = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, likey.getUser_id());
			pstmt.setLong(2, likey.getBoard_seq());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[BoardDao]likeDelete SQLExcption", e);
			}finally {
				DBManager.close(pstmt, conn);
			}

			return count;
	}
}
