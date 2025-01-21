package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable {	

	private static final long serialVersionUID = 1L;
	
	private long board_seq;
	private String user_id;
	private String user_nickname;
	private String board_title;
	private String board_content;
	private String board_category;
	
	private int board_read_cnt;
	private int board_like_cnt;
	private int board_comment_cnt;
	
	private String board_reg_date;		
	private String board_modi_date;
	private String board_del_date;
	
	private long startRow;
	private long endRow;
	
	public Board() {
		board_seq = 0;
		user_id	= "";
		user_nickname = "";
		board_title = "";
		board_content = "";
		board_category = "";
		board_read_cnt = 0;
		board_like_cnt = 0;
		board_comment_cnt = 0;
		board_reg_date = "";
		board_modi_date = "";
		board_del_date = "";
		
		startRow = 0;
		endRow = 0;
	}
	
	public long getStartRow() {
		return startRow;
	}


	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}


	public long getEndRow() {
		return endRow;
	}


	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}	
	
	public long getBoard_seq() {
		return board_seq;
	}
	public void setBoard_seq(long board_seq) {
		this.board_seq = board_seq;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_nickname() {
		return user_nickname;
	}
	public void setUser_nickname(String user_nickname) {
		this.user_nickname = user_nickname;
	}
	public String getBoard_title() {
		return board_title;
	}
	public void setBoard_title(String board_title) {
		this.board_title = board_title;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public String getBoard_category() {
		return board_category;
	}
	public void setBoard_category(String board_category) {
		this.board_category = board_category;
	}
	public int getBoard_read_cnt() {
		return board_read_cnt;
	}
	public void setBoard_read_cnt(int board_read_cnt) {
		this.board_read_cnt = board_read_cnt;
	}
	public int getBoard_like_cnt() {
		return board_like_cnt;
	}
	public void setBoard_like_cnt(int board_like_cnt) {
		this.board_like_cnt = board_like_cnt;
	}
	public int getBoard_comment_cnt() {
		return board_comment_cnt;
	}
	public void setBoard_comment_cnt(int board_comment_cnt) {
		this.board_comment_cnt = board_comment_cnt;
	}
	public String getBoard_reg_date() {
		return board_reg_date;
	}
	public void setBoard_reg_date(String board_reg_date) {
		this.board_reg_date = board_reg_date;
	}
	public String getBoard_modi_date() {
		return board_modi_date;
	}
	public void setBoard_modi_date(String board_modi_date) {
		this.board_modi_date = board_modi_date;
	}
	public String getBoard_del_date() {
		return board_del_date;
	}
	public void setBoard_del_date(String board_del_date) {
		this.board_del_date = board_del_date;
	}
				
			
}
