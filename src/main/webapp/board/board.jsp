<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.BoardDao"%>
<%@ page import="com.sist.web.model.Board"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.web.model.Paging"%>
<%@ page import="com.sist.web.model.BoardFileConfig"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.regex.Pattern"%>

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
	
	//LOG
	logger.debug("searchType: " + searchType);
	logger.debug("searchValue: " + searchValue);
	logger.debug("sortType: " + sortType);
	logger.debug("curPage: " + curPage);

	
	//보여줄 게시물을 담은 리스트(list), 페이징 처리를 위한 Paging, 페이징 처리 값을 담은 Search, 객체를 선언 or 생성
	List<Board> list = null;
	Paging paging = null;
	Board search = new Board();
	
	//DB 조작을 위한 BoardDao 생성
	BoardDao boardDao = new BoardDao();
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/resources/css/board.css">
<style>
@charset "UTF-8";

body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f9f9f9;
}

.search-container {
    display: flex;
    justify-content: center;
    padding: 20px;
    background-color: #fff;
    border-bottom: 1px solid #ddd;
}

.search-bar {
    width: 400px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px 0 0 4px;
    outline: none;
}

.search-button {
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-left: none;
    border-radius: 0 4px 4px 0;
    background-color: #fff;
    cursor: pointer;
}

.results-info {
    display: flex;
    justify-content: space-between;
    padding: 15px 240px;
    background-color: #fff;
    border-bottom: 1px solid #ddd;
    align-items: center;
}

.results-info span {
    font-size: 14px;
    color: #666;
}


.sort-option {
    position: relative;
    display: inline-block;
    width: 150px;
    font-size: 14px;
    padding: 10px 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: #fff;
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    cursor: pointer;
    background-image: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDE0TDcgOUgxN0wxMiAxNFoiIGZpbGw9IiM2NjYiLz4KPC9zdmc+Cg==');
    background-repeat: no-repeat;
    background-position: right 10px center;
    background-size: 10px;
}

.sort-option:focus {
    border-color: #aaa;
}

.sort-option option {
    padding: 10px;
}

.results {
    padding: 20px 240px;
}

.result-item {
    display: flex;
    margin-bottom: 20px;
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    max-height: 150px;
    overflow: hidden;
    white-space: normal;
}

.result-item p{

      display: -webkit-box;
      display: -ms-flexbox;
      display: box;
      margin-top:14px;
      max-height:80px;
      overflow:hidden;
      vertical-align:top;
      text-overflow: ellipsis;
      word-break:break-all;
      -webkit-box-orient:vertical;
      -webkit-line-clamp:3
      
	
}

.result-img {
    width: 150px;
    height: 150px;
    object-fit: cover;
}

#_searchType{
   
   border: 1px solid #ddd;
    border-radius: 4px;
    margin-right: 4px;
   
}

.result-content {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 15px;
    position: relative;
    flex: 1;
}

.result-title {
    font-size: 18px;
    margin: 10px 0 0 0;  /* 위쪽에 10px 여백 추가 */
    color: #333;
}

.result-description {
    font-size: 14px;
    color: #555;
    margin: 10px 0;
}

.result-author {
    position: absolute;
    top: 15px;
    right: 15px;
    font-size: 12px;
    color: #888;
}

.result-stats {
    font-size: 12px;
    color: #666;
}

.result-stats span {
    margin-right: 10px;
}

/* a 태그의 밑줄 제거 */
.result-link {
    text-decoration: none; /* 밑줄 제거 */
    color: inherit; /* 링크의 글자색을 부모 요소에 상속 */
}

/* 제목에 hover 시 링크 색 강조 */
.result-link:hover .result-title {
    color: #00a884; /* 원하는 색상으로 변경 */
    text-decoration: underline; /* hover 시 밑줄을 추가할 수 있음 */
}

.pagination {
    display: flex;
    justify-content: center;
    margin: 30px 0;
    padding-bottom: 100px;
}

.pagination a {
    text-decoration: none;
    color: #333;
    padding: 10px 15px;
    border: 1px solid #ddd;
    margin: 0;
    border-radius: 4px;
    font-size: 14px;
}

.pagination a:hover {
    background-color: #f0f0f0;
    color: #000;
}

.pagination .active a {
    background-color: #333333a6;
    color: #fff;
    font-weight: bold;
}

.prev-page, .next-page {
    font-weight: bold;
}
.write-btn {
    display: inline-block;
    margin-left: 30px;
    border-color: #00a884; 
   display: flex;
   justify-content: flex-end;
}

.btn-write {
    background-color: #00a884;
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    border-radius: 5px;
    border-color: #00a884; 
    cursor: pointer;
    margin-right: 240px;
}

.btn-write:hover {
    background-color: #00a884;
}

#btnSearch:hover {
   transition-duration: 1s;
    background-color : #86D293;
    color: #fff;
}


</style>
<script>
	$(document).ready(function(){
		
		$("#btnWrite").on("click", function(){
			
			location.href = "/board/writeForm.jsp";
			
		});
		
	});
	
   $(document).ready(function() {
	   
	<%
	    
	    //총 댓글수 조회
	    commtotalcount = boardDao.commentTotalCount(boardSeq);    
	    //LOG
	    logger.debug("commtotalcount: " + commtotalcount);
	    
	    
	%>
	   
      //검색 후 검색 조건(searchType)과 검색 값(searchValue)을 보여주기 위해 받은 값을 태그에 세팅
      $("#_searchType").val("<%=searchType%>");
      $("#_searchValue").val("<%=searchValue%>");
      $("#_sortType").val("<%=sortType%>");
      
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
      
      //search객체를 전체 게시물의 갯수 조회
      totalCount = boardDao.boardTotalCount(search);
      
      //LOG
      logger.debug("totalCount: " + totalCount);
      
      //게시물이 있는 경우, 전체 게시물의 갯수(totalCount), 화면에 보여줄 게시물의 갯수(boardFileConfig.LIST_COUNT), 화면에 보여줄 페이지의 갯수(boardFileConfig.PAGE_COUNT), 현재 페이지를 매개변수로 paging 객체 생성
      if (totalCount > 0) {
          paging = new Paging(totalCount, BoardFileConfig.LIST_COUNT,
        		  							BoardFileConfig.PAGE_COUNT, curPage);
          
          //paging 객체를 통해 설정된 현제 페이지의 시작번호(startRow)와 마지막번호(endRow)를 search 객체에 세팅
          search.setStartRow(paging.getStartRow());
          search.setEndRow(paging.getEndRow());
         
         //search를 매개변수로, boardList 매서드 실행 -> boardList 매서드: search객체의 값을 기준으로 게시물 출력(search 객체의 값에 따라 페이징 처리, where조건에 맞는 게시물들을 list에 담아 반환)
         list = boardDao.boardList(search, sortType);
         
         logger.debug("list size : " + list.size());
      }
%>

      //검색조건(searchType)이 바뀌면 검색 값(searchValue)도 ""로 초기화
      $("#_searchType").change(function() {
         $("#_searchValue").val("");
      });
      
      //글쓰기 버튼(btnWrite) 클릭 시 게시물 작성(/board/write.jsp)으로 폼(bbsForm)의 값들(검색조건(searchType), 검색 값(searchValue), 현재 페이지(curPage), 게시물 번호(bbsSeq))을 submit()
      $("#btnWrite").on("click", function() {
         document.bbsForm.action = "/board/writeForm.jsp";
         document.bbsForm.submit();
      });
      
      //검색 버튼(btnSearch) 클릭 시 검색타입(searchType)과, 검색 값(searchValue)이 정상적으로 세팅되었는지 체크 후 해당 값들(searchType, searchValue, curPage->""으로 초기회)을 게시판(/board/list.jsp)으로 submit();
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
      $("#_sortType").change(function(){
         document.bbsForm.sortType.value = $("#_sortType").val();
         document.bbsForm.curPage.value = "";
         document.bbsForm.action = "/board/board.jsp";
         document.bbsForm.submit();
      });
   });
   
   //페이지 번호 or 다음블럭 or 이전 블럭을 통해 이동할 페이지의 번호를 매개변수로 받아 게시판(/board/list.jps)로 submit()
   function fn_list(movePage){
      document.bbsForm.curPage.value = movePage;
      document.bbsForm.action = "/board/board.jsp";
      document.bbsForm.submit();
   }
   
   //게시물 번호를 매개변수로 받아 게시물의 상세페이지(/board/view.jsp)로 submit();
   function fn_view(boardSeq){
	  document.bbsForm.boardSeq.value = boardSeq;
      document.bbsForm.action = "/board/view.jsp";
      document.bbsForm.submit();
     
   }
</script>
</head>
<body>
    <%@ include file="/include/navigation.jsp" %>
    <div class="search-container">
       <select name="_searchType" id="_searchType" style="width:auto;">
          <option value="">조회 항목</option>
          <option value="1"<% if(StringUtil.equals(searchType, "1")){ %>selected<% } %>>작성자</option>
          <option value="2"<% if(StringUtil.equals(searchType, "2")){ %>selected<% } %>>제목</option>
          <option value="3"<% if(StringUtil.equals(searchType, "3")){ %>selected<% } %>>내용</option>
       </select>
        <input type="text" id="_searchValue" name="_searchValue" class="search-bar" placeholder="검색어를 입력해주세요.">
        <button id="btnSearch" class="search-button" type="button">🔍</button>
    </div>

    <div class="results-info">
        <span><%= totalCount %>개의 검색 결과</span>
        <select class="sort-option" name="_sortType" id="_sortType">
         <option value="">정렬</option>
         <option value="1">최신순</option>
         <option value="2">오래된순</option>
         <option value="3">조회순</option>
         <option value="4">좋아요순</option>	 
         <option value="5">댓글순</option>
        </select>
    </div>
      
<%
	if(list != null && list.size() > 0) {
	long startNum = paging.getStartNum();
		for (int i = 0; i < list.size(); i++) {
		Board board = list.get(i);
		String htmlContent = board.getBoard_content();
        
        Pattern pattern = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
        Matcher matcher = pattern.matcher(htmlContent);
        
        String imgSrc = "";

          while (matcher.find()) {
              imgSrc = matcher.group(1);
              break;
          }
          
          
          // 정규 표현식을 사용하여 img 태그를 포함하는 p 태그 전체를 제거
          // <p> 태그 내에 <img> 태그가 포함되어 있는 경우 해당 p 태그 전체를 제거하는 정규식 패턴
          String imgContainingPTagPattern = "<p[^>]*>.*?<img[^>]*>.*?</p>"; // <p>...</p> 태그 중간에 <img>가 있는 경우

          // Pattern과 Matcher를 사용하여 img 태그가 포함된 p 태그 전체를 찾음
          Pattern pattern1 = Pattern.compile(imgContainingPTagPattern, Pattern.CASE_INSENSITIVE);
          Matcher matcher1 = pattern.matcher(htmlContent);

          // img 태그를 포함한 p 태그를 제거한 문자열 생성
          String modifiedHtml = matcher1.replaceAll("");     
            
       %>

        <div class="results">
        
        <div class="result-item">
            <img src="<%= imgSrc %>" class="result-img" onerror="this.onerror=null; this.src='/resources/images/noimage.jpg'">
            <div class="result-content">
                <a href="#" onclick="fn_view(<%= board.getBoard_seq() %>)" class="result-link"><%= board.getBoard_title() %><br/><%= modifiedHtml %></a>


                <!-- 작성자 및 작성 날짜 -->
                <div class="result-author">작성자: <%= board.getUser_nickname()%>  | 작성일: <%= board.getBoard_modi_date() %> </div>

                <!-- 추천수 및 조회수 -->
                <div class="result-stats">
                    <span>좋아요수: <%= board.getBoard_like_cnt() %></span>
                    <span>조회수: <%= board.getBoard_read_cnt() %></span>
                    <span>댓글수: <%= board.getBoard_comment_cnt() %></span>
                </div>
            </div>
        </div>
   </div>
   <%
      startNum--;
      }
   }else {
	   
   %>
   <div class="results">
        <div class="result-item">
            <div class="result-content">
            <h3 class="result-title">해당 데이터가 존재하지 않습니다.</h3>
            <p class="result-description">
               조건에 맞추어 다시 검색해주세요😀
            </p>
         </div>
      </div>
   </div>
     <%
    }
     %>
   <div class="write-btn">
        <button type="button"  class="btn-write" id="btnWrite">글쓰기</button>
   </div>
   <nav>
      <ul class="pagination justify-content-center">
      <%
//--------------------------------------------------------------------------------------------------------------------------------------------------
      if(paging != null){
      %>
      <!--해당 <li>태그 클릭 시 fn_list(movePage) 매서드의 매개변수 1을 넣어 실행 -> fn_list(movePage): 이동할 페이지 번호를 매개변수로 받아 게시판(/board/list.jps)로 submit()-->
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(1)">처음</a></li >
      <%
      //이전 블럭이 있다면 -> getPrevBlockPage: 현재 블럭의 첫번째 페이지 -1(이전 블럭의 마지막 페이지), 현재 블럭이 1이거나 작다면 초기 값인 0
       if(paging.getPrevBlockPage() > 0){   
      %>            
         <!--해당 <li>태그 클릭 시 fn_list(movePage) 매서드의 매개변수 paging.getPrevBlockPage()를 넣어 실행, paging.getPrevBlockPage() -> 현재 블럭의 첫번째 페이지 -1(이전 블럭의 마지막 페이지) -->
         <li class="prev-page"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getPrevBlockPage()%>)">이전블럭</a></li>
      <%
       }
      //해당 블럭에서 보여지는 첫번째 페이지 번호부터, 마지막 페이지 번호까지 반복 -> 보여질 페이지 번호가 5개이면 1,2,3,4,5 
      for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++){
          //현재 페이지가 아닐 때, <li>에 i값을 넣고 클릭 시 fn_list(i)실행
          if(paging.getCurPage() != i){
      %>            
            <li class="page-number"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=i%>)"><%=i%></a></li>
      <%
         }
          //현재 페이지와 일치할 때, <li>에 i값을 넣고 style="cursor: default" 설정 
         else{   
      %>
            <li class="page-number active"><a class="page-link" href="javascript:void(0)" style="cursor: default;"><%=i%></a></li>
      <%
         }
      }
      //다음 블럭이 있다면 -> getPrevBlockPage: 현재 블럭의 마지막 페이지 +1(다음 블럭의 첫번째 페이지), 현재 블럭이 마지막 블럭일 경우 초기 값인 0
      if(paging.getNextBlockPage() > 0){
      %>
         <!--해당 <li>태그 클릭 시 fn_list(movePage) 매서드의 매개변수 paging.getNextBlockPage()를 넣어 실행 -> paging.getNextBlockPage(): 현재 블럭의 마지막 페이지 +1(다음 블럭의 첫번째 페이지) -->
         <li class="page-item"><a class="next-page" href="javascript:void(0)" onclick="fn_list(<%=paging.getNextBlockPage()%>)">다음블럭</a></li>
      <%
      }
      %>
      <!--해당 <li>태그 클릭 시 fn_list(movePage) 매서드의 매개변수 paging.getTotalPage()을 넣어 실행 -> paging.getTotalPage(): 총 페이지 수, 즉 마지막 페이지-->
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getTotalPage()%>)">마지막</a></li >
      <%
   }
//--------------------------------------------------------------------------------------------------------------------------------------------------
      %>
      </ul>
   </nav>
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" id="boardSeq" name="boardSeq" value="">
      <input type="hidden" id="searchType" name="searchType" value="<%=searchType%>" />
      <input type="hidden" id="searchValue" name="searchValue" value="<%=searchValue%>" />
      <input type="hidden" id="curPage" name="curPage" value="<%=curPage%>" />
      <input type="hidden" id="sortType" name="sortType" value="<%=sortType%>">
   </form>

<!-- 
<div class="pagination">
    <a href="#" class="prev-page">&lt;</a>
    <a href="#" class="page-number active">1</a>
    <a href="#" class="page-number">2</a>
    <a href="#" class="page-number">3</a>
    <a href="#" class="page-number">4</a>
    <a href="#" class="page-number">5</a>
    <a href="#" class="next-page">&gt;</a>
    </div>
-->

</body>
</html>
