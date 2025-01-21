/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.util
 * 파일명     : HttpUtil.java
 * 작성일     : 2020. 12. 29.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.util;

import java.io.File;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.logging.log4j.Logger;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.util
 * 파일명     : HttpUtil.java
 * 작성일     : 2020. 12. 29.
 * 작성자     : daekk
 * 설명       : HTTP 통신 관련 유틸리티
 * </pre>
 */
public final class HttpUtil
{
	private HttpUtil() {}

	/**
	 * <pre>
	 * 메소드명   : getRealPath
	 * 작성일     : 2020. 12. 29.
	 * 작성자     : daekk
	 * 설명       : Servlet 웹 루트 경로를 얻는다.(절대경로)
	 * </pre>
	 * @param request HttpServletRequest
	 * @return String
	 */
	public static String getRealPath(HttpServletRequest request)
	{
		return getRealPath(request, "/");
	}
	
	/**
	 * <pre>
	 * 메소드명   : getRealPath
	 * 작성일     : 2020. 12. 29.
	 * 작성자     : daekk
	 * 설명       : Servlet 웹 루트 경로를 얻는다.(절대경로)
	 * </pre>
	 * @param request HttpServletRequest
	 * @param path 경로
	 * @return String
	 */
	public static String getRealPath(HttpServletRequest request, String path)
	{
		if(request != null)
		{
			if(path != null)
			{	
				return request.getSession().getServletContext().getRealPath(path);
			}
			else
			{
				return request.getSession().getServletContext().getRealPath("/");
			}
		}
		else
		{
			return null;
		}
	}

	/**
	 * <pre>
	 * 메소드명   : isAjax
	 * 작성일     : 2020. 12. 29.
	 * 작성자     : daekk
	 * 설명       : AJAX 호출 여부 체크
	 * </pre>
	 * @param request HttpServletRequest
	 * @return boolean
	 */
	public static boolean isAjax(HttpServletRequest request)
	{
		if(request != null)
		{
			return StringUtil.equalsIgnoreCase("XMLHttpRequest", request.getHeader("X-Requested-With"));
		}
		
		return false;
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @return String
	 * </pre>
	 */
	public static String get(HttpServletRequest request, String name)
	{
		if(name == null)
		{
			return "";
		}
		
		return StringUtil.nvl(request.getParameter(name)).trim();
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return String
	 * </pre>
	 */
	public static String get(HttpServletRequest request, String name, String defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			return str;
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return short
	 * </pre>
	 */
	public static short get(HttpServletRequest request, String name, short defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			try 
			{
				short result = Short.parseShort(str);
				
				return result;
			}
			catch(NumberFormatException e)
			{
				return defValue;
			}
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return int
	 * </pre>
	 */
	public static int get(HttpServletRequest request, String name, int defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			try 
			{
				int result = Integer.parseInt(str);
				
				return result;
			}
			catch(NumberFormatException e)
			{
				return defValue;
			}
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return long
	 * </pre>
	 */
	public static long get(HttpServletRequest request, String name, long defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			try 
			{
				long result = Long.parseLong(str);
				
				return result;
			}
			catch(NumberFormatException e)
			{
				return defValue;
			}
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return float
	 * </pre>
	 */
	public static float get(HttpServletRequest request, String name, float defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			try 
			{
				float result = Float.parseFloat(str);
				
				return result;
			}
			catch(NumberFormatException e)
			{
				return defValue;
			}
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : get
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 값을 가져온다.
	 *                  값이 없을시 defaultValue로 대체
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @param defValue 기본값
	 * @return double
	 * </pre>
	 */
	public static double get(HttpServletRequest request, String name, double defValue)
	{
		String str = get(request, name);
		
		if(StringUtil.isEmpty(str))
		{
			return defValue;
		}
		else
		{
			try 
			{
				double result = Double.parseDouble(str);
				
				return result;
			}
			catch(NumberFormatException e)
			{
				return defValue;
			}
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : gets
	 * 메소드 설명    : HttpServletRequest 객체에서 Paramter name과 일치하는 값을 가져온다.
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @return String[]
	 * </pre>
	 */
	public static String[] gets(HttpServletRequest request, String name)
	{
		return request.getParameterValues(name);
	}
	
	/**
	 * <pre>
	 * 메소드명   : getMap
	 * 작성일     : 2020. 12. 29.
	 * 작성자     : daekk
	 * 설명       : HttpServletRequest 객체에서 Paramter를 Map<String, String[]> 형태로 가져온다.
	 * </pre>
	 * @param request javax.servlet.http.HttpServletRequest
	 * @return java.util.Map<String, String[]>
	 */
	public static Map<String, String[]> getMap(HttpServletRequest request)
	{
		return request.getParameterMap();
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : getHeader
	 * 메소드 설명    : HttpServletRequest 객체에서 name과 일치하는 헤더 정보를 가져온다.
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * @param request javax.servlet.http.HttpServletRequest
	 * @param name 이름
	 * @return String
	 * </pre>
	 */
	public static String getHeader(HttpServletRequest request, String name)
	{
		if(name == null)
		{
			return "";
		}
		
		return StringUtil.nvl(request.getHeader(name));
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : getHeaders
	 * 메소드 설명    : HttpServletRequest 객체에서 전체 헤더 정보를 가져온다.
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * @param request javax.servlet.http.HttpServletRequest
	 * @return java.util.Map
	 * </pre>
	 */
	public static Map<String, String> getHeaders(HttpServletRequest request)
	{
		Map<String, String> map = new HashMap<String, String>();
		
		Enumeration<String> headers = request.getHeaderNames();
        while(headers.hasMoreElements())
        {
        	String key = (String) headers.nextElement();
        	String value = request.getHeader(key);
        	map.put(key, value);
        }
        		
		return map;
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : getIP
	 * 메소드 설명    : 호출자의 IP를 가져온다.
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request HttpServletRequest
	 * @return String
	 * </pre>
	 */
	public static String getIP(HttpServletRequest request)
	{
		String[] headers = {"X-FORWARDED-FOR", 
				            "X-Forwarded-For", 
				            "Proxy-Client-IP", 
				            "WL-Proxy-Client-IP", 
				            "HTTP_CLIENT_IP", 
				            "HTTP_X_FORWARDED_FOR", 
				            "X-Real-IP", 
				            "X-RealIP"};
		
		String strIP = getIP(request, headers);

		return strIP;
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : getIP
	 * 메소드 설명    : 호출자의 IP를 가져온다.
	 *                  (WAS 는 보통 2차 방화벽 안에 있고 Web Server 를 통해 client 에서 호출되거나 cluster로 구성되어 
	 *                   load balancer 에서 호출되는데 이럴 경우에서 getRemoteAddr() 을 호출하면 웹서버나 load balancer의 IP 가 나옴)
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request HttpServletRequest
	 * @param headers 헤더 배열
	 * @return String
	 * </pre>
	 */
	public static String getIP(HttpServletRequest request, String[] headers)
	{
		if(headers == null)
		{
			return request.getRemoteAddr();
		}
		
		String strIP = null;
		
		for(int i=0; i<headers.length; i++)
		{
			strIP = getHeaderIP(request, headers[i]);
			
			if(strIP != null && strIP.length() != 0 && !"unknown".equalsIgnoreCase(strIP))
			{
				if(strIP.indexOf(",") > -1)
				{
					String[] ipArray = StringUtil.tokenizeToStringArray(strIP, ",");
					
					if(ipArray != null && ipArray.length > 0)
					{
						strIP = StringUtil.trim(ipArray[0]);
					}
				}
				
				break;
			}
		}
		
		if(strIP == null || strIP.length() == 0 || "unknown".equalsIgnoreCase(strIP))
		{
			strIP = request.getRemoteAddr();
		}
		
		return strIP;
	}

	/**
	 * 
	 * <pre>
	 * 메소드명       : getHeaderIP
	 * 메소드 설명    : 호출자의 IP를 가져온다.
	 *                  (WAS 는 보통 2차 방화벽 안에 있고 Web Server 를 통해 client 에서 호출되거나 cluster로 구성되어 
	 *                   load balancer 에서 호출되는데 이럴 경우에서 getRemoteAddr() 을 호출하면 웹서버나 load balancer의 IP 가 나옴)
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : daekk
	 * 수정이력       :
	 * @param request HttpServletRequest
	 * @param header 헤더
	 * @return String
	 * </pre>
	 */
	public static String getHeaderIP(HttpServletRequest request, String header)
	{
		if(header == null)
		{
			return null;
		}
				
		return request.getHeader(header);
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명      : getUrlDecode
	 * 메소드 설명   : 값을 UTF-8로 Decode 한다.
	 * 작성일        : 2020. 12. 29.
	 * 작성자        : daekk 
	 * @param str 값
	 * @return String
	 * </pre>
	 */
	public static String getUrlDecode(String str)
	{
		return getUrlDecode(str, "UTF-8");
	}
	
	/**
	 * <pre>
	 * 메소드명   : getUrlDecode
	 * 작성일     : 2020. 12. 29.
	 * 작성자     : daekk
	 * 설명       :
	 * </pre>
	 * @param str
	 * @param charset
	 * @return String
	 */
	public static String getUrlDecode(String str, String charset)
	{
		if(!StringUtil.isEmpty(str))
		{
			String strDecode = "";
			
			if(StringUtil.isEmpty(charset))
			{
				charset = "UTF-8";				
			}	
			
			try 
			{
				Charset _charset = Charset.forName(charset);
				charset = _charset.name();
	        } 
			catch (Exception e) 
			{
				Charset _charset = Charset.forName("UTF-8");
				charset = _charset.name();
	        } 
			
			try
			{
				strDecode = URLDecoder.decode(str, charset);
			}
			catch(Exception e)
			{
				e.printStackTrace();
				
				return str;
			}
			
			return strDecode;
		}
		else
		{
			return str;
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명      : getUrlEncode
	 * 메소드 설명   : 값을 UTF-8로 Encode 한다.
	 * 작성일        : 2020. 12. 29.
	 * 작성자        : 
	 * 수정이력      :
	 * @param str 값
	 * @return String
	 * </pre>
	 */
	public static String getUrlEncode(String str)
	{
		return getUrlEncode(str, "UTF-8");
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : getUrlEncode
	 * 메소드 설명   : 값을 charset으로 Encode 한다.
	 *
	 * 작성일          : 2020. 12. 29.
	 * 작성자          : 
	 * 수정이력       :
	 * @param str 값
	 * @param charset 캐릭터셋
	 * @return String
	 * </pre>
	 */
	public static String getUrlEncode(String str, String charset)
	{
		if(!StringUtil.isEmpty(str))
		{
			String strEncode = "";
			
			if(StringUtil.isEmpty(charset))
			{
				charset = "UTF-8";				
			}
			
			try 
			{
				Charset _charset = Charset.forName(charset);
				charset = _charset.name();
	        } 
			catch (Exception e) 
			{
				Charset _charset = Charset.forName("UTF-8");
				charset = _charset.name();
	        } 
			
			try
			{
				strEncode = URLEncoder.encode(str, charset);
			}
			catch(Exception e)
			{
				e.printStackTrace();
				
				return str;
			}
			
			return strEncode;
		}
		else
		{
			return str;
		}
	}
	
	/**
	 * 
	 * <pre>
	 * 메소드명       : isHttps
	 * 메소드 설명    : 보안프로트콜 확인 (true : HTTPS, false : HTTP)
	 *
	 * 작성일         : 2020. 12. 29.
	 * 작성자         : 
	 * 수정이력       :
	 * @param request HttpServletRequest
	 * @return boolean
	 * </pre>
	 */
	public static boolean isHttps(HttpServletRequest request)
	{
		if(request.isSecure())
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : requestLogString
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : HTTP 로그
	 * </pre>
	 * @param request HttpServletRequest
	 * @param logger org.apache.logging.log4j.Logger
	 */
	public static void requestLogString(HttpServletRequest request, Logger logger)
	{
		if(request == null || logger == null)
		{
			return;
		}
		
		String lineSeparator = FileUtil.getLineSeparator(); //개행문자 체크
		StringBuilder sb = new StringBuilder();  //기존 데이터에 더하는 방식, 속도가 빠르고 부하가 적음.
		
		sb.append(lineSeparator);
		sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
		sb.append("[Remote IP] : [" + HttpUtil.getIP(request) + "]"+lineSeparator);
		sb.append("[Locale]    : [" + request.getLocale() + "]"+lineSeparator);
		sb.append("[URL]       : [" + request.getRequestURL() + "]"+lineSeparator);
        sb.append("[URI]       : [" + request.getRequestURI() + "]"+lineSeparator);
        sb.append("[Method]    : [" + request.getMethod() + "]"+lineSeparator);
        sb.append("[Protocol]  : [" + request.getProtocol() + "]"+lineSeparator);
        sb.append("[Referer]   : [" + StringUtil.nvl(request.getHeader("Referer")) + "]"+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("// Headers                                                                      "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
                
        Enumeration<String> headers = request.getHeaderNames();
        while(headers.hasMoreElements())
        {
            String name = headers.nextElement();
        	Enumeration<String> values = request.getHeaders(name);
            
            if(values != null)
            {	
                while(values.hasMoreElements())
                {
                	sb.append("[" + name + "] : [" + StringUtil.nvl(values.nextElement()) + "]" + lineSeparator);
                }
            }
        }
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        sb.append(lineSeparator);
        if(StringUtil.equalsIgnoreCase(request.getMethod(), "get"))
        {
        	sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append("// Get Parameters                                                               "+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append(getUrlDecode(StringUtil.nvl(request.getQueryString()), "UTF-8")+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        }
        else
        {
    	    sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append("// Post Parameters                                                              "+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            
            Enumeration<String> params = request.getParameterNames();
            if(params.hasMoreElements())
            {	
	            while(params.hasMoreElements())
	            {
	                String name = params.nextElement();
	                String[] values = request.getParameterValues(name);
	
	                if(values != null)
	                {
	                    for(int i=0; i<values.length; i++)
	                    {
	                        sb.append("["+name+"] : " + (values[i] != null ? "["+values[i]+"]" : "[null]")+lineSeparator);
	                    }
	                }
	
	            }
            }
            
            sb.append("////////////////////////////////////////////////////////////////////////////////");
        }
        
        logger.debug(sb.toString());
	}
	
	/**
	 * <pre>
	 * 메소드명   : requestLogString
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : HTTP 로그
	 * </pre>
	 * @param request HttpServletRequest
	 * @return String
	 */
	public static String requestLogString(HttpServletRequest request)
	{
		if(request == null)
		{
			return "";
		}
		
		String lineSeparator = System.getProperty("line.separator");
		StringBuilder sb = new StringBuilder();
		
		sb.append(lineSeparator);
		sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
		sb.append("[Remote IP] : [" + HttpUtil.getIP(request) + "]"+lineSeparator);
		sb.append("[Locale]    : [" + request.getLocale() + "]"+lineSeparator);
		sb.append("[URL]       : [" + request.getRequestURL() + "]"+lineSeparator);
        sb.append("[URI]       : [" + request.getRequestURI() + "]"+lineSeparator);
        sb.append("[Method]    : [" + request.getMethod() + "]"+lineSeparator);
        sb.append("[Protocol]  : [" + request.getProtocol() + "]"+lineSeparator);
        sb.append("[Referer]   : [" + StringUtil.nvl(request.getHeader("Referer")) + "]"+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("// Headers                                                                      "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
                
        Enumeration<String> headers = request.getHeaderNames();
        while(headers.hasMoreElements())
        {
            String name = headers.nextElement();
        	Enumeration<String> values = request.getHeaders(name);
            
            if(values != null)
            {	
                while(values.hasMoreElements())
                {
                	sb.append("[" + name + "] : [" + StringUtil.nvl(values.nextElement()) + "]" + lineSeparator);
                }
            }
        }
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        sb.append(lineSeparator);
        if(StringUtil.equalsIgnoreCase(request.getMethod(), "get"))
        {
        	sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append("// Get Parameters                                                               "+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append(getUrlDecode(StringUtil.nvl(request.getQueryString()), "UTF-8")+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        }
        else
        {
    	    sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            sb.append("// Post Parameters                                                              "+lineSeparator);
            sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
            
            Enumeration<String> params = request.getParameterNames();
            if(params.hasMoreElements())
            {	
	            while(params.hasMoreElements())
	            {
	                String name = params.nextElement();
	                String[] values = request.getParameterValues(name);
	
	                if(values != null)
	                {
	                    for(int i=0; i<values.length; i++)
	                    {
	                        sb.append("["+name+"] : " + (values[i] != null ? "["+values[i]+"]" : "[null]")+lineSeparator);
	                    }
	                }
	
	            }
            }
            
            sb.append("////////////////////////////////////////////////////////////////////////////////");
        }
        
        return sb.toString();
	}
	
	/**
	 * <pre>
	 * 메소드명   : requestLogString
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : 아파치 common file upload 모듈 사용시 로그
	 * </pre>
	 * @param request HttpServletRequest
	 * @param items List<FileItem>
	 * @return String
	 */
	public static String requestLogString(HttpServletRequest request, List<FileItem> items)
	{
		if(request == null)
		{
			return "";
		}
		
		String lineSeparator = System.getProperty("line.separator");
		StringBuilder sb = new StringBuilder();
		
		sb.append(lineSeparator);
		sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
		sb.append("[Remote IP] : [" + HttpUtil.getIP(request) + "]"+lineSeparator);
		sb.append("[Locale]    : [" + request.getLocale() + "]"+lineSeparator);
		sb.append("[URL]       : [" + request.getRequestURL() + "]"+lineSeparator);
        sb.append("[URI]       : [" + request.getRequestURI() + "]"+lineSeparator);
        sb.append("[Method]    : [" + request.getMethod() + "]"+lineSeparator);
        sb.append("[Protocol]  : [" + request.getProtocol() + "]"+lineSeparator);
        sb.append("[Referer]   : [" + StringUtil.nvl(request.getHeader("Referer")) + "]"+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("// Headers                                                                      "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
                
        Enumeration<String> headers = request.getHeaderNames();
        while(headers.hasMoreElements())
        {
            String name = headers.nextElement();
        	Enumeration<String> values = request.getHeaders(name);
            
            if(values != null)
            {	
                while(values.hasMoreElements())
                {
                	sb.append("["+name+"] : [" + StringUtil.nvl(values.nextElement()) + "]"+lineSeparator);
                }
            }
        }
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        sb.append(lineSeparator);
        
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("//  Multipart Parameters                                                        "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        if(items != null && items.size() > 0)
        {
        	Iterator<FileItem> iterator = items.iterator();
        	
        	try
        	{
	        	while(iterator.hasNext())
	        	{
	        		FileItem fileItem = iterator.next();
	
	        		if(fileItem != null)
	        		{
	        			if(fileItem.isFormField()) 
	        			{
	        				// 파일이 아니면
	        				String name = fileItem.getFieldName();
	        				String value = fileItem.getString("UTF-8");
	        				
	        				sb.append("["+name+"] : ["+value+"]"+lineSeparator);
	        			}
	        			else
	        			{
	        				// 파일이면
	        				String name = fileItem.getFieldName();
	        				String fileName = fileItem.getName();
	        				String contentType = fileItem.getContentType();
	        				long fileSize = fileItem.getSize();
	        				
	        				sb.append("["+name+"] : [" + fileName + "] {contentType: "+contentType+", size: " + byteToDisplayString(fileSize, "#,###.##") + "}"+lineSeparator);
	        			}
	        		}
	        	}
        	}
        	catch(Exception e)
        	{
        		e.printStackTrace();
        	}
        }
        
        sb.append("////////////////////////////////////////////////////////////////////////////////");
        
        return sb.toString();
	}
	
	/**
	 * <pre>
	 * 메소드명   : requestLogString
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : 아파치 common file upload 모듈 사용시 로그
	 * </pre>
	 * @param request HttpServletRequest
	 * @param items List<FileItem>
	 * @param logger org.apache.logging.log4j.Logger
	 */
	public static void requestLogString(HttpServletRequest request, List<FileItem> items, Logger logger)
	{
		if(request == null || items == null || logger == null)
		{
			return;
		}
		
		String lineSeparator = System.getProperty("line.separator");
		StringBuilder sb = new StringBuilder();
		
		sb.append(lineSeparator);
		sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
		sb.append("[Remote IP] : [" + HttpUtil.getIP(request) + "]"+lineSeparator);
		sb.append("[Locale]    : [" + request.getLocale() + "]"+lineSeparator);
		sb.append("[URL]       : [" + request.getRequestURL() + "]"+lineSeparator);
        sb.append("[URI]       : [" + request.getRequestURI() + "]"+lineSeparator);
        sb.append("[Method]    : [" + request.getMethod() + "]"+lineSeparator);
        sb.append("[Protocol]  : [" + request.getProtocol() + "]"+lineSeparator);
        sb.append("[Referer]   : [" + StringUtil.nvl(request.getHeader("Referer")) + "]"+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("// Headers                                                                      "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
                
        Enumeration<String> headers = request.getHeaderNames();
        while(headers.hasMoreElements())
        {
            String name = headers.nextElement();
        	Enumeration<String> values = request.getHeaders(name);
            
            if(values != null)
            {	
                while(values.hasMoreElements())
                {
                	sb.append("["+name+"] : [" + StringUtil.nvl(values.nextElement()) + "]"+lineSeparator);
                }
            }
        }
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        sb.append(lineSeparator);
        
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        sb.append("//  Multipart Parameters                                                        "+lineSeparator);
        sb.append("////////////////////////////////////////////////////////////////////////////////"+lineSeparator);
        
        if(items != null && items.size() > 0)
        {
        	Iterator<FileItem> iterator = items.iterator();
        	
        	try
        	{
	        	while(iterator.hasNext())
	        	{
	        		FileItem fileItem = iterator.next();
	
	        		if(fileItem != null)
	        		{
	        			if(fileItem.isFormField()) 
	        			{
	        				// 파일이 아니면
	        				String name = fileItem.getFieldName();
	        				String value = fileItem.getString("UTF-8");
	        				
	        				sb.append("["+name+"] : ["+value+"]"+lineSeparator);
	        			}
	        			else
	        			{
	        				// 파일이면
	        				String name = fileItem.getFieldName();
	        				String fileName = fileItem.getName();
	        				String contentType = fileItem.getContentType();
	        				long fileSize = fileItem.getSize();
	        				
	        				sb.append("["+name+"] : [" + fileName + "] {contentType: "+contentType+", size: " + byteToDisplayString(fileSize, "#,###.##") + "}"+lineSeparator);
	        			}
	        		}
	        	}
        	}
        	catch(Exception e)
        	{
        		e.printStackTrace();
        	}
        }
        
        sb.append("////////////////////////////////////////////////////////////////////////////////");
        
        logger.debug(sb.toString());
	}
	
	/**
	 * <pre>
	 * 메소드명   : filter
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : 특수문자 필터링
	 * </pre>
	 * @param message 문자열
	 * @return String
	 */
	public static String filter(String message)
	{

		if (message == null)
		{
			return null;
		}

		char content[] = new char[message.length()];
		message.getChars(0, message.length(), content, 0);
		StringBuilder result = new StringBuilder(content.length + 50);
		
		for (int i = 0; i < content.length; i++)
		{
			switch (content[i])
			{
				case '<' :
					result.append("&lt;");
					break;
				case '>' :
					result.append("&gt;");
					break;
				case '&' :
					result.append("&amp;");
					break;
				case '"' :
					result.append("&quot;");
					break;
				default :
					result.append(content[i]);
			}
		}
		
		return result.toString();
	}
	
	/**
	 * <pre>
	 * 메소드명   : getFile
	 * 작성일     : 2020. 12. 31.
	 * 작성자     : daekk
	 * 설명       : 파일 업로드 - name과 일치하는 파일을 가져온다.
	 *              (commons-fileupload 사용)
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param directory 디렉토리 파일 객체
	 * @return FileData
	 */
	public static FileData getFile(List<FileItem> fileItems, String name, File directory)
	{
		FileData fileData = null;
		
		if(!FileUtil.isDircetory(directory))
		{
			return null;
		}
		
		if(StringUtil.isEmpty(name))
		{
			return null;
		}
		
		if(fileItems != null && fileItems.size() > 0)
		{
			Iterator<FileItem> iterator = fileItems.iterator();
			
			while(iterator.hasNext())
			{
				FileItem fileItem = iterator.next();
				
				if(fileItem != null)
				{
					if(!fileItem.isFormField())
					{
						if(StringUtil.equals(name, fileItem.getFieldName()))
						{
							if(fileItem.getSize() > 0)
							{
								int index =  fileItem.getName().lastIndexOf(FileUtil.getFileSeparator());
								
								String fileOrgName = StringUtil.substring(fileItem.getName(), index + 1);
								String fileExt = FileUtil.getFileExtension(fileOrgName);
								long fileSize = fileItem.getSize();
								String fileName = FileUtil.uniqueFileName(fileExt);
								String filePath = FileUtil.getCanonicalPath(directory) + FileUtil.getFileSeparator() + fileName;
								
								if(fileItemWrite(fileItem, new File(filePath)) == true)
								{
									fileData = new FileData();
									
									fileData.setName(name);
									fileData.setFileOrgName(fileOrgName);
									fileData.setFileName(fileName);
									fileData.setFileExt(fileExt);
									fileData.setFileSize(fileSize);
									fileData.setFilePath(filePath);
									fileData.setContentType(fileItem.getContentType());
									
									return fileData;
								}
							}
						}
					}
				}
			}
		}
		
		return null;
	}
	
	/**
	 * <pre>
	 * 메소드명   : getFiles
	 * 작성일     : 2020. 12. 31.
	 * 작성자     : daekk
	 * 설명       : 파일 업로드 - name과 일치하는 파일 리스트를 가져온다.
	 *              (commons-fileupload 사용)
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param directory 디렉토리 경로 문자열
	 * @return List<UploadFile>
	 */
	public static List<FileData> getFiles(List<FileItem> fileItems, String name, String directory)
	{
		return getFiles(fileItems, name, new File(directory));
	}
	
	/**
	 * <pre>
	 * 메소드명   : getFiles
	 * 작성일     : 2020. 12. 31.
	 * 작성자     : daekk
	 * 설명       : 파일 업로드 - name과 일치하는 파일 리스트를 가져온다.
	 *              (commons-fileupload 사용)
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param directory 디렉토리 파일 객체
	 * @return List<UploadFile>
	 */
	public static List<FileData> getFiles(List<FileItem> fileItems, String name, File directory)
	{
		List<FileData> list = null;
		
		if(!FileUtil.isDircetory(directory))
		{
			return null;
		}
		
		if(StringUtil.isEmpty(name))
		{
			return null;
		}
		
		if(fileItems != null && fileItems.size() > 0)
		{
			list = new ArrayList<FileData>();
			
			Iterator<FileItem> iterator = fileItems.iterator();
			
			while(iterator.hasNext())
			{
				FileItem fileItem = iterator.next();
				
				if(fileItem != null)
				{
					if(!fileItem.isFormField())
					{
						if(StringUtil.equals(name, fileItem.getFieldName()))
						{
							if(fileItem.getSize() > 0)
							{
								int index =  fileItem.getName().lastIndexOf(FileUtil.getFileSeparator());
								
								String fileOrgName = StringUtil.substring(fileItem.getName(), index + 1);
								String fileExt = FileUtil.getFileExtension(fileOrgName);
								long fileSize = fileItem.getSize();
								String fileName = FileUtil.uniqueFileName(fileExt);
								String filePath = FileUtil.getCanonicalPath(directory) + FileUtil.getFileSeparator() + fileName;
								
								if(fileItemWrite(fileItem, new File(filePath)) == true)
								{
									FileData fileData = new FileData();
									
									fileData.setName(name);
									fileData.setFileOrgName(fileOrgName);
									fileData.setFileName(fileName);
									fileData.setFileExt(fileExt);
									fileData.setFileSize(fileSize);
									fileData.setFilePath(filePath);
									fileData.setContentType(fileItem.getContentType());
									
									list.add(fileData);
								}
							}
						}
					}
				}
			}
		}
		
		
		if(list != null && list.size() > 0)
		{
			return list;
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return String
	 */
	public static String get(List<FileItem> fileItems, String name, String charset, String defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			Iterator<FileItem> iterator = fileItems.iterator();
			
			while(iterator.hasNext())
			{
				FileItem fileItem = iterator.next();
				
				if(fileItem != null)
				{
					if(fileItem.isFormField())
					{
						if(StringUtil.equals(fileItem.getFieldName(), name))
						{
							String value = getFiled(fileItem, charset);
							
							if(value == null)
							{
								value = defValue;
							}
							
							return value;
						}
					}
				}
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return short
	 */
	public static short get(List<FileItem> fileItems, String name, String charset, short defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			String value = get(fileItems, name, charset, null);
			
			if(StringUtil.isShort(value))
			{
				return Short.parseShort(value);
			}
			else
			{
				return defValue;
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return int
	 */
	public static int get(List<FileItem> fileItems, String name, String charset, int defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			String value = get(fileItems, name, charset, null);
			
			if(StringUtil.isInteger(value))
			{
				return Integer.parseInt(value);
			}
			else
			{
				return defValue;
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return long
	 */
	public static long get(List<FileItem> fileItems, String name, String charset, long defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			String value = get(fileItems, name, charset, null);
			
			if(StringUtil.isLong(value))
			{
				return Long.parseLong(value);
			}
			else
			{
				return defValue;
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return float
	 */
	public static float get(List<FileItem> fileItems, String name, String charset, float defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			String value = get(fileItems, name, charset, null);
			
			if(StringUtil.isFloat(value))
			{
				return Float.parseFloat(value);
			}
			else
			{
				return defValue;
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : get
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return double
	 */
	public static double get(List<FileItem> fileItems, String name, String charset, double defValue)
	{
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			String value = get(fileItems, name, charset, null);
			
			if(StringUtil.isDouble(value))
			{
				return Double.parseDouble(value);
			}
			else
			{
				return defValue;
			}
		}
		
		return defValue;
	}
	
	/**
	 * <pre>
	 * 메소드명   : gets
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : List<FileItem> 에서 name과 일치하는 값의 배열을 가져온다.
	 * </pre>
	 * @param fileItems List<FileItem>
	 * @param name      필드명
	 * @param charset   캐릭터셋
	 * @param defValue  기본값
	 * @return String[]
	 */
	public static String[] gets(List<FileItem> fileItems, String name, String charset, String defValue)
	{
		List<String> list = null;
		
		if(fileItems != null && fileItems.size() > 0 && !StringUtil.isEmpty(name))
		{
			list = new ArrayList<String>();
			
			Iterator<FileItem> iterator = fileItems.iterator();
			
			while(iterator.hasNext())
			{
				FileItem fileItem = iterator.next();
				
				if(fileItem != null)
				{
					if(fileItem.isFormField())
					{
						if(StringUtil.equals(fileItem.getFieldName(), name))
						{
							String value = getFiled(fileItem, charset);
							
							if(value == null)
							{
								value = defValue;
							}
							
							list.add(value);
						}
					}
				}
			}
		}
		
		if(list != null && list.size() > 0)
		{
			return (String[])list.toArray(new String[0]);
		}
		else
		{
			return null;
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : byteToDisplayString
	 * 작성일     : 2020. 12. 30.
	 * 작성자     : daekk
	 * 설명       : 파일 사이즈 디스플레이 문자열을 얻는다.
	 * </pre>
	 * @param size     사이즈 
	 * @param pattern  DecimalFormat 패턴
	 * @return String
	 */
	public static String byteToDisplayString(double size, String pattern)
	{
		DecimalFormat df = null;
		
		if(pattern == null)
		{
			df = new DecimalFormat("#,###.##");
		}
		else
		{
			df = new DecimalFormat(pattern);
		}

		if(size <= 0)
		{
			return "0 byte";
		}
		else
		{
			if(size < FileUtil.KILOBYTES)
			{
				return df.format(size) + " byte";
			}
			else if(size >= FileUtil.KILOBYTES && size < FileUtil.MEGABYTES)
			{
				return df.format(size / FileUtil.KILOBYTES) + " Kbyte";
			}
			else if(size >= FileUtil.MEGABYTES && size < FileUtil.GIGABYTES)
			{
				return df.format(size / FileUtil.MEGABYTES) + " Mbyte";
			}
			else if(size >= FileUtil.GIGABYTES && size < FileUtil.TERABYTES)
			{
				return df.format(size / FileUtil.GIGABYTES) + " Gbyte";
			}
			else if(size >= FileUtil.TERABYTES && size < FileUtil.PETABYTES)
			{
				return df.format(size / FileUtil.TERABYTES) + " Tbyte";
			}
			else if(size >= FileUtil.PETABYTES && size < FileUtil.EXABYTES)
			{
				return df.format(size / FileUtil.PETABYTES) + " Pbyte";
			}
			else
			{
				return df.format(size / FileUtil.EXABYTES) + " Ebyte";
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : getFiled
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : FileItem 값을 가져온다.
	 * </pre>
	 * @param fileItem FileItem
	 * @param charset 캐릭터셋
	 * @return String
	 */
	private static String getFiled(FileItem fileItem, String charset)
	{
		String value = null;
		
		if(fileItem != null)
		{
			if(StringUtil.isEmpty(charset))
			{
				charset = "UTF-8";
			}
			
			try
			{
				value = fileItem.getString(charset);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		
		return value;
	}
	
	/**
	 * <pre>
	 * 메소드명   : fileItemWrite
	 * 작성일     : 2021. 1. 4.
	 * 작성자     : daekk
	 * 설명       : FileItem 파일을 file 객체에 쓴다.
	 * </pre>
	 * @param fileItem FileItem
	 * @param file File
	 * @return boolean
	 */
	private static boolean fileItemWrite(FileItem fileItem, File file)
	{
		boolean bFlag = false;
		
		if(fileItem != null && file != null && !fileItem.isFormField() && fileItem.getSize() > 0)
		{
			try
			{
				fileItem.write(file);
				bFlag = true;
			}
			catch (Exception e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
				bFlag = false;
			}
		}
		
		return bFlag;
	}
}
