package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.User;

public class UserDao {
	
	private static Logger logger = LogManager.getLogger(UserDao.class);
	
	//사용자 조회
	public User userSelect(String userId) {
		
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT USER_ID, ");
		sql.append("	   NVL(USER_PWD, '') USER_PWD, ");
		sql.append("	   NVL(USER_NAME, '') USER_NAME, ");
		sql.append("	   NVL(USER_NICKNAME, '') USER_NICKNAME, ");
		sql.append("	   NVL(USER_GENDER, '') USER_GENDER, ");
		sql.append("	   NVL(USER_ADDRESS, '') USER_ADDRESS, ");
		sql.append("	   NVL(USER_TEL, '') USER_TEL, ");
		sql.append("	   NVL(USER_EMAIL, '') USER_EMAIL, ");
		sql.append("	   NVL(USER_GRADE, '') USER_GRADE, ");
		sql.append("	   NVL(USER_STATUS, '') USER_STATUS, ");
		sql.append("	   NVL(TO_CHAR(USER_REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') USER_REG_DATE, ");
		sql.append("	   NVL(TO_CHAR(USER_MODI_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') USER_MODI_DATE, ");
		sql.append("	   NVL(TO_CHAR(USER_DEL_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') USER_DEL_DATE ");
		sql.append("  FROM TR_USER ");
		sql.append(" WHERE USER_ID = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				user = new User();
				
				user.setUser_id(rs.getString("USER_ID"));
				user.setUser_pwd(rs.getString("USER_PWD"));
				user.setUser_name(rs.getString("USER_NAME"));
				user.setUser_nickname(rs.getString("USER_NICKNAME"));
				user.setUser_gender(rs.getString("USER_GENDER"));
				user.setUser_address(rs.getString("USER_ADDRESS"));
				user.setUser_tel(rs.getString("USER_TEL"));
				user.setUser_email(rs.getString("USER_EMAIL"));
				user.setUser_grade(rs.getString("USER_GRADE"));
				user.setUser_status(rs.getString("USER_STATUS"));
				user.setUser_reg_date(rs.getString("USER_REG_DATE"));
				user.setUser_modi_date(rs.getString("USER_MODI_DATE"));
				user.setUser_del_date(rs.getString("USER_DEL_DATE"));
				
			}
			
		}catch(Exception e) {
			logger.error("[UserDao]userSelect SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		
		return user;
		
	}
	
	//아이디 중복검사
	public int userIdSelectCount(String userId) {
			
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(USER_ID) CNT ");			
		sql.append("FROM TR_USER ");			
		sql.append("WHERE USER_ID = ? ");	
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("CNT");
			}
			
			
		}catch(Exception e){
			
			logger.error("[UserDao]userSelect SQLException", e);
			
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return count;
	}
	
	//아이디 중복검사
	public int userNickNameSelectCount(String usernickname) {
			
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(USER_NICKNAME) CNT ");			
		sql.append("FROM TR_USER ");			
		sql.append("WHERE USER_NICKNAME = ? ");	
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, usernickname);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("CNT");
			}
			
			
		}catch(Exception e){
			
			logger.error("[UserDao]userNickNameSelectCount SQLException", e);
			
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return count;
		
	}
	
	//사용자 등록
	public int userInsert(User user) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO TR_USER ");
		sql.append("       (USER_ID, USER_PWD, USER_NAME, USER_NICKNAME, USER_GENDER, USER_ADDRESS, USER_TEL, USER_EMAIL, USER_GRADE, USER_STATUS, USER_REG_DATE, USER_MODI_DATE) ");
		sql.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE) ");
		
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUser_id());
			pstmt.setString(++idx, user.getUser_pwd());
			pstmt.setString(++idx, user.getUser_name());
			pstmt.setString(++idx, user.getUser_nickname());
			pstmt.setString(++idx, user.getUser_gender());
			pstmt.setString(++idx, user.getUser_address());
			pstmt.setString(++idx, user.getUser_tel());
			pstmt.setString(++idx, user.getUser_email());
			pstmt.setString(++idx, user.getUser_grade());
			pstmt.setString(++idx, user.getUser_status());
			
			count = pstmt.executeUpdate();
			
			
		}catch(Exception e) {
			logger.error("[UserDao]userInsert SQLException", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
		
	}
	

	//사용자 수정
	public int userUpdate(User user) {
		
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_USER ");
		sql.append("   SET USER_PWD = ?, ");
		sql.append("	   USER_NAME = ?, ");
		sql.append("	   USER_NICKNAME = ?, ");
		sql.append("	   USER_GENDER = ?, ");
		sql.append("	   USER_ADDRESS = ?, ");
		sql.append("	   USER_TEL = ?, ");
		sql.append("	   USER_EMAIL = ?, ");
		sql.append("	   USER_MODI_DATE = SYSDATE ");
		sql.append(" WHERE USER_ID = ? ");
		
		try {
			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUser_pwd());
			pstmt.setString(++idx, user.getUser_name());
			pstmt.setString(++idx, user.getUser_nickname());
			pstmt.setString(++idx, user.getUser_gender());
			pstmt.setString(++idx, user.getUser_address());
			pstmt.setString(++idx, user.getUser_tel());
			pstmt.setString(++idx, user.getUser_email());
			pstmt.setString(++idx, user.getUser_id());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			logger.error("[UserDao]userUpdate SQLException", e);
		}finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	//회원 탈퇴
	public int userDelete(User user) {
	
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE TR_USER ");	
		sql.append("   SET USER_STATUS = '탈퇴', ");
		sql.append("   	   USER_DEL_DATE = SYSDATE ");
		sql.append(" WHERE USER_ID = ? ");								
	
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, user.getUser_id());
			
			count = pstmt.executeUpdate();
			
		}catch(Exception e) {
			
			logger.error("[userDao]userDelete SQLException", e);
			
		}finally {
			
			DBManager.close(pstmt, conn);
			
		}
		
		return count;
	}
	
	//아이디 찾기
	public User FindId(String user_name, String user_email) {
		
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT USER_ID ");
		sql.append("  FROM TR_USER ");
		sql.append(" WHERE USER_NAME = ? ");
		sql.append("   AND USER_EMAIL = ? ");
						
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, user_name);
			pstmt.setString(2, user_email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				user = new User();
				user.setUser_id(rs.getString("USER_ID"));
				
			}
			
		}catch(Exception e) {
			logger.error("[UserDao]FindId SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}					
			
		return user;
		
	}
	
	
	//비밀번호 찾기
	public User FindPwd(String user_id, String user_email) {
		
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT USER_PWD ");
		sql.append("  FROM TR_USER ");
		sql.append(" WHERE USER_ID = ? ");
		sql.append("   AND USER_EMAIL = ? ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, user_id);
			pstmt.setString(2, user_email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				
				user = new User();
				user.setUser_pwd(rs.getString("USER_PWD"));
				
			}
			
			
		}catch(Exception e) {
			logger.error("[UserDao]FindPwd SQLException", e);
		}finally {
			DBManager.close(rs, pstmt, conn);
		}	

		return user;
		
	}
	
	
	
	
	

}
