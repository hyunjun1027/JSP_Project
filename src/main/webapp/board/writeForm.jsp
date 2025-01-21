<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User" %>

<%
	Logger logger = LogManager.getLogger("/board/writForm.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);
%>



<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시글 작성</title>
<!-- Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet"> 
<!-- Quill JS -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<!-- quill-image-resize-module CDN -->
<script src="https://cdn.jsdelivr.net/npm/quill-image-resize-module@3.0.0/image-resize.min.js"></script>

<%@ include file="/include/head.jsp" %>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 0;
}
.container {
	display: flex;
}
.sidebar {
	width: 200px;
	background-color: #f5f5f5;
	padding: 20px;
	box-sizing: border-box;
	border-right: 1px solid #ddd;
}
.content {
	flex: 1;
	padding: 20px;
	box-sizing: border-box;
}
.editor-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 40px 0 10px; /* 여백을 더 추가했습니다. */
}
.editor-header .title-label {
	font-size: 18px;
	font-weight: bold;
	margin-right: 10px;
}
.title-input {
	flex: 1;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 16px;
	outline: none;
}
.editor-container {
	border: 1px solid #ddd;
	border-radius: 8px;
	overflow: hidden;
	margin-bottom: 20px;
}
#editor {
	height: 510px;
}
.buttons {
	display: flex;
	justify-content: flex-end;
}
.btn {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	margin-left: 10px;
}
.btn-cancel {
	background-color: #ccc;
	color: #333;
}
.btn-submit {
	background-color: #00a884;
	color: white;
}
.btn-submit:hover {
	transition-duration: 0.3s;
	background-color: #86D293;
	color: #fff;
}

.board_summary {
	position: relative;
	margin: 0 auto 20px;
	padding-bottom: 36px; /* 아래쪽 여백 추가 */
	padding-top: 20px;
}
.board_write .left {
	width: 100%;
	max-width: 300px;
	float: left;
	position: relative;
	z-index: 100;
}
.board_summary .left {
	float: left;
	padding: 8px 0 20px;
	display: table;
}

.write-body .board_summary .avatar, .write-body .board_summary .author {
    display: inline-block;
}

.avatar {
    display: table-cell;
    padding-right: 16px;
    vertical-align: top;
}
.avatar-image {
    border-radius: 50%;
    width: 40px;
    height: 40px;
}

.board_summary .author {
    display: table-cell;
    vertical-align: middle;
    overflow: hidden;
    line-height: 1.2;
    text-align: left;
}

.ql-toolbar.ql-snow {
	  border: 1px solid #ccc;
	  box-sizing: border-box;
	  font-family: 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
	  padding: 8px;
	  background-color: #4c4c4c;
}

.ql-snow .ql-stroke {
    fill: none;
    stroke: #fff;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-width: 2;
}
.ql-snow .ql-fill, .ql-snow .ql-stroke.ql-fill {
    fill: #fff;
}
.ql-snow .ql-picker-label::before {
    color: #fff;
    display: inline-block;
    line-height: 22px;
}
#category{
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 16px;
	outline: none;
}


</style>
<script>
    // 전역 변수로 quill 선언
    var quill;

    // DOMContentLoaded 이벤트 후 Quill 초기화
    document.addEventListener("DOMContentLoaded", function () {
        quill = new Quill('#editor', {
            theme: 'snow',
            modules: {
                toolbar: [
                    ['bold', 'italic', 'underline', 'strike'],
                    [{ 'header': 1 }, { 'header': 2 }],
                    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                    [{ 'size': ['small', false, 'large', 'huge'] }],
                    ['link', 'image']  // 이미지 버튼 추가
                ],
                imageResize: {
                    displayStyles: {
                        backgroundColor: 'black',
                        border: '1px solid red',
                        borderRadius: '4px',
                        color: 'white'
                    },
                    modules: ['Resize', 'DisplaySize', 'Toolbar']
                }
            }
        });
    });

    // jQuery 사용 시 버튼 클릭 이벤트 리스너
    $(document).ready(function () {
        $("#btn-submit").on("click", function () {
            // quill 객체가 존재하는지 확인
            if (typeof quill === 'undefined') {
                alert("Quill 에디터가 초기화되지 않았습니다.");
                return;
            }

            if ($.trim($("#title").val()).length <= 0) {
                alert("제목을 입력하세요.");
                $("#boardTitle").val("");
                $("#boardTitle").focus();
                return;
            }

            var content = quill.root.innerHTML;
            if ($.trim(content).length <= 0 || content === "<p><br></p>") {
                alert("내용을 입력하세요.");
                quill.focus();
                return;
            }

            // 숨겨진 input 필드에 Quill 내용을 설정
            $('<input>').attr({
                type: 'hidden',
                name: 'content',
                id: 'content',
                value: content
            }).appendTo('#writeForm');

            // 폼 제출
            document.writeForm.submit();
        });
    });
</script>
</head>
<body>
	<div class="container">
		<form name="writeForm" id="writeForm" action="/board/writeProc.jsp" method="post" style="display: contents;">
		    <div class="sidebar">
		        <div><h5>대표 이미지 설정</h5></div>
		        <img src="/resources/images/background4.jpg" alt="대표 이미지" style="width: 100%; margin-top: 10px;">
		    </div>
		    <div class="content">
		        <!-- 프로필 이미지와 이름 섹션 -->
		        <div class="board_summary">
		            <div class="left">
		                <div class="avatar ">
		                    <img alt="프로필 이미지" src="/resources/images/default_profile.png" class="avatar-image">
		                </div>
		                <div class="author">
		                    <div class="write"><%= user.getUser_nickname() %></div>
		                </div>
		            </div>
		        </div>
		
		        <!-- 제목 입력란 -->
		        <!-- 
		       <div class="editor-header">
	               <select name="category" id="category">
		               <option value="">종류</option>
		               <option value="한식">한식</option>
		               <option value="중식">중식</option>
		               <option value="일식">일식</option>
		               <option value="양식">양식</option>
		               <option value="그 외">그 외</option>
	               </select>
		        </div>
		        -->
		        <div class="editor-header">
		            <input type="text" id="title" name="title" class="title-input" placeholder="제목" required>
		        </div>
		        <div class="editor-container">
		            <div id="toolbar">
		                <!-- 툴바 영역 -->
		            </div>
		            <div id="editor">
		                <!-- 텍스트 편집기 -->
		            </div>
		        </div>
		
		        <div class="buttons">
		            <button class="btn btn-cancel" id="btn-cancel" name="btn-cancel" type="button" onclick="history.back()">취소</button>

		            <button class="btn btn-submit" id="btn-submit" name="btn-submit" type="button">작성</button>
		        </div>
		    </div>	
		</form>
	</div>
</body>
</html>
