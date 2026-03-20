<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아티스트 관리</title>

    <!-- SB Admin 2 -->
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">

    <!-- DataTables -->
    <link href="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

    <style>
        .write-wrap {
            max-width: 1100px;
            margin: 40px auto;
        }

        .section-title {
            margin-top: 10px;
            margin-bottom: 15px;
            font-weight: bold;
            color: #4e73df;
        }

        .artist-form-card .card-body {
            padding: 2rem;
        }

        .artist-table-card .card-body {
            padding: 1.25rem;
        }

        .table td, .table th {
            vertical-align: middle !important;
        }

        .toggle-link {
            text-decoration: none !important;
            font-weight: 700;
            color: #4e73df;
        }

        .toggle-link:hover {
            color: #224abe;
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
    </style>
</head>
<body>

<div class="container-fluid write-wrap">

    <!-- 페이지 헤더 -->
    <div class="page-header-box">
        <div>
            <h2>아티스트 관리</h2>
            <div class="sub-text">아티스트 조회 및 등록 페이지</div>
        </div>
    </div>

    <!-- 메시지 -->
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
        <a class="toggle-link" data-toggle="collapse" href="#artistListCollapse" role="button" aria-expanded="true" aria-controls="artistListCollapse">
            아티스트 목록 보기 / 숨기기
        </a>
    </div>

    <div class="collapse show" id="artistListCollapse">
        <div class="card shadow mb-4 artist-table-card">
            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 font-weight-bold text-primary">등록된 아티스트 목록</h6>
                <span class="badge badge-primary">
                    총 <c:out value="${empty artistList ? 0 : artistList.size()}" />명
                </span>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="artistTable" class="table table-bordered table-hover text-center" width="100%" cellspacing="0">
                        <thead class="thead-light">
                            <tr>
                                <th style="width: 140px;">아티스트 ID</th>
                                <th>아티스트명</th>
                                <th style="width: 320px;">이미지 경로</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="artist" items="${artistList}">
                                <tr>
                                    <td>${artist.artistId}</td>
                                    <td>${artist.artistName}</td>
                                    <td class="text-left">${artist.profileImageUrl}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:if test="${empty artistList}">
                        <div class="text-center text-muted mt-3">
                            등록된 아티스트가 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- 등록 폼 -->
    <div class="card shadow mb-4 artist-form-card">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">아티스트 등록</h6>
        </div>
        <div class="card-body">
            <form action="${adminUrl}/music/admin_artist" method="post" enctype="multipart/form-data">

                <div class="form-group">
                    <label for="artistName">
                        아티스트명
                        <span class="required-mark">*</span>
                    </label>
                    <input type="text" id="artistName" name="artistName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="artistImageFile">
                        아티스트 이미지 업로드
                        <span class="required-mark">*</span>
                    </label>
                    <input type="file" id="artistImageFile" name="artistImageFile" class="form-control-file" accept="image/*" required>
                    <small class="form-text text-muted">
                        저장 경로: /resources/music/img/파일명
                    </small>
                </div>

                <div class="mt-4 text-right">
                    <button type="submit" class="btn btn-primary px-4">등록</button>
                    <a href="${adminUrl}/music/admin_artist" class="btn btn-secondary px-4">새로고침</a>
                </div>

            </form>
        </div>
    </div>

</div>

<!-- jQuery -->
<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap -->
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- SB Admin 2 -->
<script src="${adminRes}/js/sb-admin-2.min.js"></script>

<!-- DataTables -->
<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script>
$(document).ready(function () {
    $('#artistTable').DataTable({
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