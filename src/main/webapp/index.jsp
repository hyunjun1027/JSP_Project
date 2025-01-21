<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.model.User"%>
<%
	//LOG
	Logger logger = LogManager.getLogger("/board/board.jsp");
	HttpUtil.requestLogString(request, logger);
	
	//페이지 로딩 전, 검색 조건(searchType), 검색 값(searchValue), 현제 페이지(curPage)를 변수에 받음
	//조회항목(1: 닉네임, 2: 제목, 3:내용)
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	String sortType = HttpUtil.get(request, "sortType", "");
	long totalCount = 0;
	long commtotalcount = 0;

	Board search = new Board();

	
	//DB 조작을 위한 BoardDao 생성
	BoardDao boardDao = new BoardDao();
%>
<!DOCTYPE html>
<html>
<%@ include file="/include/head.jsp" %>
<style>
   /* Basic Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    color: #333;
}

/* Header */
header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #fff;
    padding: 20px;
    border-bottom: 1px solid #ddd;
}

.logo img {
    height: 50px;
}

nav ul {
    list-style-type: none;
    display: flex;
    gap: 20px;
}

nav ul li {
    display: inline;
}

nav ul li a {
    text-decoration: none;
    color: #333;
    font-weight: bold;
}

.login button {
    background-color: #00a884;
    color: #fff;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

/* Search Section */
.search-section {
    text-align: right;
    padding: 180px 180px;
    background: url('/resources/images/imggg.jpg') no-repeat center center/cover;
    color: black;
    
}

.search-section h1 {
    font-weight: bolder;
    font-size: 2.8rem;
    margin-bottom: 10px;
    text-shadow: -1px 0px black, 0px 1px black, 1px 0px black, 0px -1px black;
}

.search-section p {
    font-size: 1.1rem;
    margin-bottom: 30px;
}

.search-section input {
    padding: 10px;
    width: 400px;
    height: 40px;
    border: none;
    border-radius: 5px;
    margin-bottom: 20px;
    outline: none;
}

.location-buttons button {
    background-color: #00a884;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    margin: 5px;
    cursor: pointer;
}

/* Recommendations Section */
.recommendations {
    padding: 40px;
    background-color: #fff;
}

.keywords {
    text-align: center;
    margin-bottom: 30px;
}

.keywords h2 {
    font-size: 2rem;
    color: #00a884;
    margin-bottom: 10px;
}

.grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}

.card {
    background-color: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.card img {
    width: 100%;
    /*height: 200px;*/
    /*object-fit: cover;*/
}

.card p {
    padding: 20px;
    text-align: center;
    font-size: 1.1rem;
}

#btnSearch {
     background-color: #00a884;
     color: white;
     padding: 10px 20px;
     border: none;
     border-radius: 5px;
     cursor: pointer;
}

#btnSearch:hover {
	transition-duration: 1s;
    background-color : #86D293;
    color: #fff;
}
#_searchType {
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 10px 3px;
}
   
</style>
<script>
	
	$(document).ready(function(){
		
		$("#btnSearch").on("click", function() {
		    if ($("#_searchType").val() != "") {
		       if ($.trim($("#_searchValue").val()) == "") {
		          alert("조회 항목 선택 시 조회 값을 입력하세요.");
		          $("#_searchValue").val("");
		          $("#_searchValue").focus();
		          return;
		       }
		    }
		
		    document.bbsForm.searchType.value = $("#_searchType").val();
		    document.bbsForm.searchValue.value = $("#_searchValue").val();
		    document.bbsForm.curPage.value = "";
		    document.bbsForm.sortType.value = "";
		    document.bbsForm.action = "/board/board.jsp";
		    document.bbsForm.submit();
		 });
		
	});

</script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 추천 커뮤니티</title>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<% 
          //검색 조건(searchType)과 검색 값(searchValue)을 확인하여 값이 있다면 검색 조건(searchType)에 따라 검색 값(searchValue) 세팅
      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
         if (StringUtil.equals(searchType, "1")) {
            search.setUser_nickname(searchValue);
         }
         else if (StringUtil.equals(searchType, "2")) {
            search.setBoard_title(searchValue);
         }
         else if (StringUtil.equals(searchType, "3")) {
            search.setBoard_content(searchValue);
         }
      }
%>
    <!-- Main Content -->
    <section class="search-section">
        <h1>쌍용 강북학원<br> 점심 추천 커뮤니티</h1>
        <p>쌍용테이스티로드에 오신 것을 환영합니다</p>
        <select name="_searchType" id="_searchType" style="width:auto;">
			<option value="">조회 항목</option>
			<option value="1"<% if(StringUtil.equals(searchType, "1")){ %>selected<% } %>>작성자</option>
			<option value="2"<% if(StringUtil.equals(searchType, "2")){ %>selected<% } %>>제목</option>
			<option value="3"<% if(StringUtil.equals(searchType, "3")){ %>selected<% } %>>내용</option>
        </select>
        <input type="text" id="_searchValue" name="_searchValue" class="search-bar" placeholder="검색어를 입력해주세요!">
        <button type="button" id="btnSearch" name="btnSearch">검색</button>
    </section>

    <!-- Restaurant Recommendations -->
<!-- 
    <section class="recommendations">
        <div class="keywords">
            <h2>가장 인기있는 식당</h2>
            <p>쌍용 강북 학원 학생들이 직접 추천하는 음식점!</p>
        </div>

        <div class="grid">
            <div class="card">
                <a href="/board/view.jsp"><img src="/resources/images/noimage.jpg"></a>
                게시물 1
                <br>
                식당 이름 평점
                <br>
                내용
            </div>
            <div class="card">
               <img src="/resources/images/noimage.jpg">
            
                게시물 2
            </div>
            <div class="card">
                <img src="/resources/images/noimage.jpg">
                게시물 3
            </div>
        </div>
    </section>
 -->    
    <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" id="boardSeq" name="boardSeq" value="">
      <input type="hidden" id="searchType" name="searchType" value="<%=searchType%>" />
      <input type="hidden" id="searchValue" name="searchValue" value="<%=searchValue%>" />
      <input type="hidden" id="curPage" name="curPage" value="<%=curPage%>" />
      <input type="hidden" id="sortType" name="sortType" value="<%=sortType%>">
    </form>
</body>
</html>