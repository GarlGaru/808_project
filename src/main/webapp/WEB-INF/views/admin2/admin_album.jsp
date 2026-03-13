<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>앨범 관리</title>

    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

    <style>
        .write-wrap {
            max-width: 1100px;
            margin: 40px auto;
        }

        .album-form-card .card-body {
            padding: 2rem;
        }

        .album-table-card .card-body {
            padding: 1.25rem;
        }

        .table td, .table th {
            vertical-align: middle !important;
        }

        .required-mark {
            color: #e74a3b;
            margin-left: 4px;
        }

        .page-header-box {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .page-header-box h2 {
            margin: 0;
            font-weight: 700;
            color: #2e2e2e;
        }

        .sub-text {
            color: #858796;
            font-size: 0.95rem;
        }

        .cover-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }

        .toggle-link {
            text-decoration: none !important;
            font-weight: 700;
            color: #4e73df;
        }

        .toggle-link:hover {
            color: #224abe;
        }
    </style>
</head>
<body>

<div class="container-fluid write-wrap">

    <div class="page-header-box">
        <div>
            <h2>앨범 관리</h2>
            <div class="sub-text">앨범 조회 및 등록 페이지</div>
        </div>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="close" data-dismiss="alert" aria-label="닫기">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <!-- 접이식 목록 -->
    <div class="mb-4">
        <a class="toggle-link" data-toggle="collapse" href="#albumListCollapse" role="button" aria-expanded="true" aria-controls="albumListCollapse">
            앨범 목록 보기 / 숨기기
        </a>
    </div>

    <div class="collapse show" id="albumListCollapse">
        <div class="card shadow mb-4 album-table-card">
            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">등록된 앨범 목록</h6>
                <span class="badge badge-primary">
                    총 <c:out value="${empty albumList ? 0 : albumList.size()}" />개
                </span>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="albumTable" class="table table-bordered table-hover text-center" width="100%" cellspacing="0">
                        <thead class="thead-light">
                            <tr>
                                <th style="width:100px;">앨범 ID</th>
                                <th style="width:120px;">커버</th>
                                <th>앨범명</th>
                                <th>아티스트</th>
                                <th style="width:180px;">발매일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="album" items="${albumList}">
                                <tr>
                                    <td>${album.albumId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty album.coverImageUrl}">
                                                <img src="${ctx}${album.coverImageUrl}" class="cover-thumb" alt="cover">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">이미지 없음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${album.albumTitle}</td>
                                    <td>${album.artistName}</td>
                                    <td>${album.releaseDate}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${empty albumList}">
                        <div class="text-center text-muted mt-3">
                            등록된 앨범이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- 등록 -->
    <div class="card shadow mb-4 album-form-card">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">앨범 등록</h6>
        </div>
        <div class="card-body">
            <form action="${adminUrl}/music/admin_album" method="post" enctype="multipart/form-data">

                <div class="form-group">
                    <label for="artistId">
                        아티스트 선택
                        <span class="required-mark">*</span>
                    </label>
                    <select id="artistId" name="artistId" class="form-control" required>
                        <option value="">선택하세요</option>
                        <c:forEach var="artist" items="${artistList}">
                            <option value="${artist.artistId}">
                                ${artist.artistName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="albumTitle">
                        앨범명
                        <span class="required-mark">*</span>
                    </label>
                    <input type="text" id="albumTitle" name="albumTitle" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="albumImageFile">앨범 이미지 업로드</label>
                    <input type="file" id="albumImageFile" name="albumImageFile" class="form-control-file" accept="image/*">
                    <small class="form-text text-muted">
                        저장 경로: /resources/music/img/파일명
                    </small>
                </div>

                <div class="form-group">
                    <label for="releaseDate">발매일</label>
                    <input type="date" id="releaseDate" name="releaseDate" class="form-control">
                </div>

                <div class="mt-4 text-right">
                    <button type="submit" class="btn btn-primary px-4">등록</button>
                    <a href="${adminUrl}/music/admin_album" class="btn btn-secondary px-4">새로고침</a>
                </div>

            </form>
        </div>
    </div>

</div>

<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>
<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script>
$(document).ready(function () {
    $('#albumTable').DataTable({
        pageLength: 10,
        lengthChange: false,
        ordering: true,
        searching: true,
        info: true,
        language: {
            emptyTable: "데이터가 없습니다.",
            lengthMenu: "_MENU_ 개씩 보기",
            info: "_START_ - _END_ / _TOTAL_",
            infoEmpty: "0 / 0",
            infoFiltered: "(전체 _MAX_개 중 검색결과)",
            search: "검색 : ",
            zeroRecords: "검색 결과가 없습니다.",
            paginate: {
                first: "처음",
                last: "마지막",
                next: "다음",
                previous: "이전"
            }
        }
    });
});
</script>

</body>
</html>