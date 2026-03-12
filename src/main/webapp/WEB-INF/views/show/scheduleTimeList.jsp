<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="t" items="${list}">
   <%--  <button type="button" class="time-btn" onclick="selectTime(this, '${t.startTime}')">
        ${t.startTime}
    </button> --%>
    <button type="button" 
            class="time-btn" 
            data-schedule-id="${t.scheduleId}" 
            onclick="selectTime(this, '${t.startTime}')">
        ${t.startTime}
    </button>
</c:forEach>

  
<c:if test="${empty list}">
    <div style="color:white; padding:20px;">해당 날짜에는 공연 회차가 없습니다.</div>
</c:if>