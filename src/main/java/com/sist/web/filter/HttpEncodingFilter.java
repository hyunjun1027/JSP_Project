/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.filter
 * 파일명     : HttpEncodingFilter.java
 * 작성일     : 2020. 12. 30.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 패키지명   : com.icia.web.filter
 * 파일명     : HttpEncodingFilter.java
 * 작성일     : 2020. 12. 30.
 * 작성자     : daekk
 * 설명       : HTTP Encoding 필터
 * </pre>
 */
public class HttpEncodingFilter implements Filter
{
	private String encoding;
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
    public void init(FilterConfig filterConfig) throws  ServletException 
	{
		encoding = filterConfig.getInitParameter("encoding");
          
        // 인코딩을 따로 지정하지 않은 경우 기본값 세팅
        if(encoding == null) 
        {
        	encoding = "UTF-8";
        }
    }

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException
	{
		request.setCharacterEncoding(encoding);
		filterChain.doFilter(request, response);
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	@Override
    public void destroy() 
	{
		
    }
}
