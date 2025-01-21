package com.sist.web.model;

import java.io.Serializable;

public class Likey implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String user_id;
	private long board_seq;
	
	public Likey() {
		user_id = "";
		board_seq = 0;
	}
	
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public long getBoard_seq() {
		return board_seq;
	}
	public void setBoard_seq(long board_seq) {
		this.board_seq = board_seq;
	}
	

}
