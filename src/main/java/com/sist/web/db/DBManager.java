/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.db
 * 파일명     : DBManager.java
 * 작성일     : 2021. 1. 5.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * <pre>
 * 패키지명   : com.icia.web.db
 * 파일명     : DBManager.java
 * 작성일     : 2021. 1. 5.
 * 작성자     : daekk
 * 설명       : DB 관리자
 * </pre>
 */
public final class DBManager
{
	private static Logger logger = LogManager.getLogger(DBManager.class);
	
	private DBManager() {}

	/**
	 * <pre>
	 * 메소드명   	: getConnection
	 * 작성일     : 2021. 1. 9.
	 * 작성자     : daekk
	 * 설명      	: 데이터베이스 연결 객체를 얻는다.
	 * </pre>
	 * @return java.sql.Connection
	 */
	public static Connection getConnection()
	{
		Connection conn = null;
		
		try
		{
			// Context 객체 생성
			Context context = new InitialContext();
            // context 객체의 lookup 메서드를 이용해 "java:comp/env" 에 해당하는 객체를 얻는다.
			// JNDI 스팩으로 정의되어 있음 java:comp/env(루트임) 밑에서 읽어옴.(tomcat 환경에 ROOT.xml 에 Resource 적용해야함)
            Context envContext = (Context)context.lookup("java:comp/env");
            // envContext 객체의 lookup 메서드를 이용해 "jdbc/icia"에 해당하는 객체(DataSource)를 얻는다.
            DataSource dataSource = (DataSource)envContext.lookup("jdbc/icia");
            // getConnection 메서드를 이용해서 커넥션 풀로 부터 커넥션 객체를 얻는다.
            conn = dataSource.getConnection();

			// 아래 처럼 간략하게 설정 가능
			/*
			Context context = new InitialContext();
			DataSource dataSource = (DataSource)context.lookup("java:comp/env/jdbc/icia");
			conn = dataSource.getConnection();
			*/
		}
		catch (NamingException e)
		{
			logger.error("[DBManager] getConnection NamingException", e);
		}
		catch (SQLException e)
		{
			logger.error("[DBManager] getConnection SQLException", e);
		}
	    		
		return conn;
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : ResultSet 객체를 닫는다.
	 * </pre>
	 * @param rs java.sql.ResultSet
	 */
	public static void close(ResultSet rs)
	{
		close(rs, null, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : PreparedStatement 객체를 닫는다.
	 * </pre>
	 * @param pstmt java.sql.PreparedStatement
	 */
	public static void close(PreparedStatement pstmt)
	{
		close(null, pstmt, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : Connection 객체를 닫는다.
	 * </pre>
	 * @param conn java.sql.Connection
	 */
	public static void close(Connection conn)
	{
		close(null, null, conn);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : ResultSet, PreparedStatement 객체를 닫는다.
	 * </pre>
	 * @param rs    java.sql.ResultSet
	 * @param pstmt java.sql.PreparedStatement
	 */
	public static void close(ResultSet rs, PreparedStatement pstmt)
	{
		close(rs, pstmt, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : PreparedStatement, Connection 객체를 닫는다.
	 * </pre>
	 * @param pstmt java.sql.PreparedStatement
	 * @param conn  java.sql.Connection
	 */
	public static void close(PreparedStatement pstmt, Connection conn)
	{
		close(null, pstmt, conn);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : 데이터베이스 객체를 닫는다.
	 * </pre>
	 * @param rs    java.sql.ResultSet
	 * @param pstmt java.sql.PreparedStatement
	 * @param conn  java.sql.Connection
	 */
	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn)
	{
		if(rs != null)
		{
			try
			{
				rs.close();
			}
			catch (SQLException e)
			{
				logger.error("[DBManager] close ResultSet SQLException", e);
			}
		}
		
		if(pstmt != null)
		{
			try
			{
				pstmt.close();
			}
			catch (SQLException e)
			{
				logger.error("[DBManager] close PreparedStatement SQLException", e);
			}
		}
		
		if(conn != null)
		{
			try
			{
				conn.close();
			}
			catch (SQLException e)
			{
				logger.error("[DBManager] close Connection SQLException", e);
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : setAutoCommit
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : commit 모드 변경
	 * </pre>
	 * @param conn java.sql.Connection
	 * @param flag boolean
	 */
	public static void setAutoCommit(Connection conn, boolean flag)
	{
		if(conn != null)
		{
			try
			{
				if(conn.getAutoCommit() != flag)
				{
					conn.setAutoCommit(flag);
				}
			}
			catch (SQLException e)
			{
				logger.error("[DBManager] setAutoCommit SQLException", e);
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : rollback
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : rollback
	 * </pre>
	 * @param conn java.sql.Connection
	 */
	public static void rollback(Connection conn)
	{
		if(conn != null)
		{
			try
			{
				conn.rollback();
			}
			catch (SQLException e)
			{
				logger.error("[DBManager] rollback SQLException", e);
			}
		}
	}
}
