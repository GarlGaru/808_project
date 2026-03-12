<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>음악 등록</title>
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        .write-wrap {
            max-width: 900px;
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

        .textarea-detail {
            min-height: 140px;
            resize: vertical;
        }

        .textarea-lyrics {
            min-height: 320px;
            resize: vertical;
            line-height: 1.6;
        }

        .form-text-guide {
            font-size: 13px;
            color: #858796;
            margin-top: 6px;
        }
    </style>
</head>
<body>

<div class="container write-wrap">
    <h2 class="mb-4">음악 등록</h2>

    <form action="${adminUrl}/music/write" method="post" enctype="multipart/form-data">

        <h4 class="section-title">노래 기본 정보</h4>

        <div class="form-group">
            <label>노래 ID</label>
            <input type="number" name="songId" class="form-control" required>
        </div>

        <div class="form-group">
            <label>노래 제목</label>
            <input type="text" name="songTitle" class="form-control" required>
        </div>

        <hr>

        <h4 class="section-title">아티스트 선택</h4>

        <div class="form-group">
            <label>아티스트</label>
            <select name="artistId" class="form-control" required>
                <option value="">아티스트 선택</option>
                <c:forEach var="artist" items="${artistList}">
                    <option value="${artist.artistId}">
                        ${artist.artistName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr>

        <h4 class="section-title">앨범 선택</h4>

        <div class="form-group">
            <label>앨범</label>
            <select name="albumId" class="form-control" required>
                <option value="">앨범 선택</option>
                <c:forEach var="album" items="${albumList}">
                    <option value="${album.albumId}">
                        ${album.albumTitle}
                    </option>
                </c:forEach>
            </select>
        </div>

        <hr>

        <h4 class="section-title">장르 선택</h4>

        <div class="form-group">
            <label>장르 (여러 개 선택 가능)</label>
            <select name="genreIds" class="form-control" multiple size="6" required>
                <c:forEach var="genre" items="${genreList}">
                    <option value="${genre.genreId}">
                        ${genre.genreName}
                    </option>
                </c:forEach>
            </select>
            <div class="form-text-guide">
                Ctrl(또는 Cmd) + 클릭으로 여러 장르를 선택할 수 있습니다.
            </div>
        </div>

        <hr>

        <h4 class="section-title">노래 상세 정보</h4>

        <div class="form-group">
            <label>노래 설명</label>
            <textarea name="detail" class="form-control textarea-detail"
                      placeholder="노래 설명을 입력하세요"></textarea>
        </div>

        <div class="form-group">
            <label>노래 가사</label>
            <textarea name="lyrics" class="form-control textarea-lyrics"
                      placeholder="노래 가사를 입력하세요"></textarea>
            <div class="form-text-guide">
                가사가 길 경우를 고려해 넓게 작성할 수 있도록 설정했습니다.
            </div>
        </div>

        <div class="form-group">
            <label>MP3 파일 업로드</label>
            <input type="file" name="songFile" class="form-control-file" accept=".mp3,audio/mpeg" required>
            <small class="form-text text-muted">
                저장 경로: /resources/music/mp3/파일명
            </small>
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