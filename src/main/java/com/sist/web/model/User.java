package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String user_id;			//회원 아이디
	private String user_pwd;		//회원 비밀번호
	private String user_name;		//회원 이름
	private String user_nickname;	//회원 닉네임
	private String user_gender;		//회원 성별
	private String user_address;	//회원 주소
	private String user_tel;		//회원 휴대폰번호
	private String user_email;		//회원 이메일
	private String user_grade;		//회원 등급
	private String user_status;		//회원 상태
	private String user_reg_date;	//회원 가입날짜
	private String user_modi_date;	//회원 수정날짜
	private String user_del_date;	//회원 탈퇴날짜
	
	public User() {
		user_id = "";
		user_pwd = "";
		user_name = "";
		user_nickname = "";
		user_gender = "";
		user_address = "";
		user_tel = "";
		user_email = "";
		user_grade = "일반사용자";
		user_status = "정지";
		user_reg_date = "";
		user_modi_date = "";
		user_del_date = "";
	}
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_pwd() {
		return user_pwd;
	}
	public void setUser_pwd(String user_pwd) {
		this.user_pwd = user_pwd;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getUser_nickname() {
		return user_nickname;
	}
	public void setUser_nickname(String user_nickname) {
		this.user_nickname = user_nickname;
	}
	public String getUser_gender() {
		return user_gender;
	}
	public void setUser_gender(String user_gender) {
		this.user_gender = user_gender;
	}
	public String getUser_address() {
		return user_address;
	}
	public void setUser_address(String user_address) {
		this.user_address = user_address;
	}
	public String getUser_tel() {
		return user_tel;
	}
	public void setUser_tel(String user_tel) {
		this.user_tel = user_tel;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getUser_grade() {
		return user_grade;
	}
	public void setUser_grade(String user_grade) {
		this.user_grade = user_grade;
	}
	public String getUser_status() {
		return user_status;
	}
	public void setUser_status(String user_status) {
		this.user_status = user_status;
	}
	public String getUser_reg_date() {
		return user_reg_date;
	}
	public void setUser_reg_date(String user_reg_date) {
		this.user_reg_date = user_reg_date;
	}
	public String getUser_modi_date() {
		return user_modi_date;
	}
	public void setUser_modi_date(String user_modi_date) {
		this.user_modi_date = user_modi_date;
	}
	public String getUser_del_date() {
		return user_del_date;
	}
	public void setUser_del_date(String user_del_date) {
		this.user_del_date = user_del_date;
	}
			
	
	
}
