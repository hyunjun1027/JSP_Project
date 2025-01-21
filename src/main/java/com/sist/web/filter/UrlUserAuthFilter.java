/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.filter
 * 파일명     : UrlUserAuthFilter.java
 * 작성일     : 2021. 1. 13.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
//import com.sist.web.dao.UserDao;
//import com.sist.web.model.User;
import com.sist.web.util.CookieUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.filter
 * 파일명     : UrlUserAuthFilter.java
 * 작성일     : 2021. 1. 13.
 * 작성자     : daekk
 * 설명       :
 * </pre>
 */
public class UrlUserAuthFilter implements Filter
{
	private static Logger logger = LogManager.getLogger(UrlUserAuthFilter.class);
	private List<String> authUrlList;
		
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
    public void init(FilterConfig filterConfig) throws  ServletException 
	{
		// 필터 초기화 함수 최초 1회만 실행된다.
		authUrlList = null;
        // 필터의 authUrl 파라미터의 값을 읽는다.		
		String authUrl = filterConfig.getInitParameter("authUrl");
          
        if(!StringUtil.isEmpty(authUrl)) // authUrl 파라미터에 값이 있다면
        {
        	// "," 구분자로 나누어 배열을 만든다.
        	String[] authUrls = StringUtil.tokenizeToStringArray(authUrl, ",");
        	
        	if(authUrls != null && authUrls.length > 0)
        	{
        		// authUrls 배열에 값이 있다면
        		// authUrlList에 값을 저장한다.
        		authUrlList = new ArrayList<String>(Arrays.asList( authUrls));
        	}
        }
    }

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException
	{
		// jsp 파일이 호출 될때 실행된다.
		// <url-pattern>*.jsp</url-pattern> <!-- 모든 jsp 파일  -->
		HttpServletRequest httpServletRequest = ((HttpServletRequest) request);
		HttpServletResponse httpServletResponse = ((HttpServletResponse) response);
		boolean bFlag = true;
		
		String url = httpServletRequest.getRequestURI(); // 호출 웹 경로를 가져온다.
		
		if(authUrlCheck(url)) // url이 인증 체크 인지 검사
		{
			logger.debug("UserAuthFilter url : " + url);
			
			// 쿠키 값으로 로그인이 되어있는지 체크
			if(!isUserLogin(httpServletRequest, httpServletResponse)) //
			{
				// 로그인이 안되어있다면 로그인 화면으롤 보낸다.
				httpServletResponse.sendRedirect("/");
				bFlag = false;
			}
		}
		
		if(bFlag)
		{
			// 정상 로그인된 사용자면 다음 필터를 호출한다.
			filterChain.doFilter(request, response);
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : isUserLogin
	 * 작성일     : 2021. 1. 13.
	 * 작성자     : daekk
	 * 설명       : 로그인 체크
	 * </pre>
	 * @param request HttpServletRequest
	 * @param response HttpServletResponse
	 * @return boolean
	 */
	private boolean isUserLogin(HttpServletRequest request, HttpServletResponse response)
	{
		/*
		String cookieUserId = CookieUtil.getValue(request, "USER_ID");
		
		if(!StringUtil.isEmpty(cookieUserId)) // 쿠키 값이 있다면
		{
			UserDao userDao = new UserDao();
			User user = userDao.userSelect(cookieUserId); // 사용자 조회
			
			if(user != null && StringUtil.equals(user.getStatus(), "Y"))
			{
				// 사용자 정보가 있으면서 status 값이 "Y" 이면 정상 로그인된 사용자
				return true;
			}
			else
			{
				// 쿠키는 있으면서 사용자 정보가 없거나 status 값이 "Y"와 같지 않다면
				// 쿠키를 삭제한다.
				CookieUtil.deleteCookie(request, response, "USER_ID");
			}
		}
		
		return false;
		*/
		return true;
	}
	
	/**
	 * <pre>
	 * 메소드명   : authUrlCheck
	 * 작성일     : 2021. 1. 13.
	 * 작성자     : daekk
	 * 설명       : 인증 체크 url인지 검사
	 * </pre>
	 * @param url 경로
	 * @return boolean
	 */
	private boolean authUrlCheck(String url)
	{
		if(authUrlList != null && authUrlList.size() > 0 && !StringUtil.isEmpty(url))
		{
			for(int i=0; i<authUrlList.size(); i++)
			{
				String checkUrl = StringUtil.trim(authUrlList.get(i));
				
				if(!StringUtil.isEmpty(checkUrl))
				{
					// url의 길이가 checkUrl길이보다 크거나 같다면
					if(checkUrl.length() <= url.length())
					{
						//startsWith : 대상 문자열이 특정 문자 또는 문자열로 시작하는지 체크하는 함수
						// url의 값이 checkUrl로 시작 된다면 인증된 사용자만 허용
						if(url.startsWith(checkUrl))
						{
							return true;
						}
					}
				}
			}
		}
		
		return false;
	}
}
