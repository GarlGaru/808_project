<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<div class="music-search-page">
    <div class="music-search-header">
        <h2>검색 결과 페이지</h2>
        <p>여기에 검색 결과 상세 내용이 들어올 예정입니다.</p>
    </div>


    <div class="music-search-body">
        <div class="music-search-empty">
           <p>입력한 검색어: ${keyword}</p>
        </div>
    </div>
   
    <c:if test="${empty keyword}">
        <p>검색어를 입력해주세요.</p>
    </c:if>

    <c:if test="${not empty keyword and empty searchList}">
        <p>검색 결과가 없습니다.</p>
    </c:if>

    <c:if test="${not empty searchList}">
        <ul>
            <c:forEach var="song" items="${searchList}">
                <li>
                    ${song.title} / ${song.artistName} / ${song.albumTitle}
                </li>
            </c:forEach>
        </ul>
    </c:if>>
</div>