<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>앨범 등록</title>
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        .write-wrap {
            max-width: 800px;
            margin: 40px auto;
        }

        .section-title {
            margin-top: 30px;
            margin-bottom: 15px;
            font-weight: bold;
            color: #4e73df;
        }

        .custom-file-label::after {
            content: "찾기";
        }
    </style>
</head>
<body>

<div class="container write-wrap">
    <h2 class="mb-4">앨범 등록</h2>

    <form action="${adminUrl}/music/write" method="post" enctype="multipart/form-data">

        <h4 class="section-title">앨범 정보</h4>
        <div class="form-group">
            <label>앨범 ID</label>
            <input type="number" name="albumId" class="form-control" required>
        </div>
        <div class="form-group">
            <label>앨범명</label>
            <input type="text" name="albumTitle" class="form-control" required>
        </div>
        <div class="form-group">
            <label>앨범 이미지 업로드</label>
            <input type="file" name="albumImageFile" class="form-control-file" accept="image/*" required>
            <small class="form-text text-muted">
                저장 경로: /resources/music/img/파일명
            </small>
        </div>
        <div class="form-group">
            <label>발매일</label>
            <input type="date" name="releaseDate" class="form-control">
        </div>

        

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">등록</button>
            <a href="${adminUrl}/music" class="btn btn-secondary">목록</a>
        </div>
    </form>

    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

</div>

</body>
</html>