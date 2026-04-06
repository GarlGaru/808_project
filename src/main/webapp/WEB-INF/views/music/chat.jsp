<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />


<div data-init="initAiChat">
    <div id="ai-chat-container">
        <div id="ai-chat-messages"></div>
        <div id="ai-chat-input-wrap">
            <div id="ai-chat-input-bar">
            <textarea id="ai-chat-msg" rows="1" placeholder="메시지를 입력하세요..."></textarea>
            <button id="ai-chat-send">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2"/></svg>
            </button>
            </div>
        </div>
    </div>
</div>