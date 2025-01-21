package com.sist.web.model;

import java.io.Serializable;

public class Comment implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long comm_seq;
	private long board_seq;
	private String user_id;
	private String user_nicname;

	private String comm_content;
	private String comm_reg_date;
	private String comm_modi_date;
	private String comm_del_date;
	
	
	public Comment () {
		
		comm_seq = 0;
		board_seq = 0;
		user_id = "";
		user_nicname = "";
		comm_content = "";
		comm_reg_date = "";
		comm_modi_date = "";
		comm_del_date = "";
		
	}
	
	public String getUser_nicname() {
		return user_nicname;
	}


	public void setUser_nicname(String user_nicname) {
		this.user_nicname = user_nicname;
	}
	
	
	public long getComm_seq() {
		return comm_seq;
	}
	public void setComm_seq(long comm_seq) {
		this.comm_seq = comm_seq;
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
	public String getComm_content() {
		return comm_content;
	}
	public void setComm_content(String comm_content) {
		this.comm_content = comm_content;
	}
	public String getComm_reg_date() {
		return comm_reg_date;
	}
	public void setComm_reg_date(String comm_reg_date) {
		this.comm_reg_date = comm_reg_date;
	}
	public String getComm_modi_date() {
		return comm_modi_date;
	}
	public void setComm_modi_date(String comm_modi_date) {
		this.comm_modi_date = comm_modi_date;
	}
	public String getComm_del_date() {
		return comm_del_date;
	}
	public void setComm_del_date(String comm_del_date) {
		this.comm_del_date = comm_del_date;
	}
	
	
}
