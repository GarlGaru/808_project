<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminRes" value="${ctx}/resources/common/admin" />
<c:set var="adminUrl" value="${ctx}/admin" />

<!DOCTYPE html>
<html lang="ko">
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin - Music Tables</title>

    <link href="${adminRes}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,300,400,600,700,800,900" rel="stylesheet">
    <link href="${adminRes}/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

    <style>
        .table td, .table th {
            vertical-align: middle;
            text-align: center;
        }

        .album-cover {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }

        .song-title {
            font-weight: 600;
            text-align: left;
        }

        .text-left {
            text-align: left !important;
        }
    </style>

</head>

<body id="page-top">

<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="${adminUrl}">
            <div class="sidebar-brand-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <div class="sidebar-brand-text mx-3">808 ADMIN</div>
        </a>

        <hr class="sidebar-divider my-0">

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/user">
                <i class="fas fa-fw fa-users"></i>
                <span>User Admin</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/pay">
                <i class="fas fa-fw fa-credit-card"></i>
                <span>Pay Admin</span>
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" href="${adminUrl}/board">
                <i class="fas fa-fw fa-clipboard-list"></i>
                <span>Board Admin</span>
            </a>
        </li>

        <li class="nav-item active">
            <a class="nav-link" href="${adminUrl}/music">
                <i class="fas fa-fw fa-music"></i>
                <span>Music Admin</span>
            </a>
        </li>

        <hr class="sidebar-divider d-none d-md-block">

    </ul>

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 shadow">
                <span class="h5 mb-0 text-gray-800">음악 관리</span>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid">

                <h1 class="h3 mb-2 text-gray-800">Music Tables</h1>
                <p class="mb-4">노래 / 아티스트 / 앨범 / 장르 목록</p>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">음악 목록</h6>
                    </div>
                    
                    <div class="d-flex justify-content-end mt-3">
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#artistModal">
                            <i class="fas fa-plus"></i> 아티스트 등록
                        </button>
                        &nbsp;
                    
                        <button type="button" class="btn btn-info" data-toggle="modal" data-target="#albumModal">
                            <i class="fas fa-plus"></i> 앨범 등록
                        </button>
                        &nbsp;
                    
                        <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#genreModal">
                            <i class="fas fa-plus"></i> 장르 등록
                        </button>
                        &nbsp;
                    </div>
                    
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%">
                                <thead class="thead-light">
                                    <tr>
                                        <th>노래 ID</th>
                                        <th>앨범 커버</th>
                                        <th>노래 제목</th>
                                        <th>아티스트</th>
                                        <th>앨범명</th>
                                        <th>장르</th>
                                        <th>발매일</th>
                                        <th>노래</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty musicList}">
                                            <c:forEach var="music" items="${musicList}">
                                                <tr>
                                                    <td>${music.songId}</td>
                                
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty music.coverImageUrl}">
                                                                <img src="${ctx}${music.coverImageUrl}"
                                                                     alt="cover"
                                                                     class="album-cover">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">이미지 없음</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                
                                                    <td>${music.songTitle}</td>
                                                    <td>${music.artistName}</td>
                                                    <td>${music.albumTitle}</td>
                                                    <td>${music.genreName}</td>
                                                    <td>${music.releaseDate}</td>
                                                    
                                                    <td class="text-left">
                                                        <span>${music.songTitle}</span>
                                                    
                                                        <c:choose>
                                                            <c:when test="${not empty music.songPath}">
                                                                <button class="btn btn-sm btn-primary"
                                                                        onclick="toggleAudio('audio${music.songId}', this)">
                                                                    재생
                                                                </button>
                                                    
                                                                <audio id="audio${music.songId}">
                                                                    <source src="${ctx}${music.songPath}" type="audio/mpeg">
                                                                </audio>
                                                            </c:when>
                                                    
                                                            <c:otherwise>
                                                                <span class="text-muted">파일 없음</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8">등록된 음악 데이터가 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-end mt-3">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#musicWriteModal">
                                <i class="fas fa-plus"></i> 음악 등록
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="sticky-footer bg-white">
            <div class="container my-auto text-center">
                <span>Copyright &copy; EZE Admin 2026</span>
            </div>
        </footer>

    </div>

</div>

<!-- 아티스트 등록 모달 -->
<div class="modal fade" id="artistModal" tabindex="-1" role="dialog" aria-labelledby="artistModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document" style="max-width: 1200px;">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="artistModalLabel">아티스트 등록</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body p-0">
                <iframe
                    src="${adminUrl}/music/admin_artist"
                    style="width:100%; height:750px; border:0;"
                    loading="lazy">
                </iframe>
            </div>

        </div>
    </div>
</div>

<!-- 앨범 등록 모달 -->
<div class="modal fade" id="albumModal" tabindex="-1" role="dialog" aria-labelledby="albumModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document" style="max-width: 1200px;">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="albumModalLabel">앨범 등록</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body p-0">
                <iframe
                    src="${adminUrl}/music/admin_album"
                    style="width:100%; height:750px; border:0;"
                    loading="lazy">
                </iframe>
            </div>

        </div>
    </div>
</div>

<!-- 장르 등록 모달 -->
<div class="modal fade" id="genreModal" tabindex="-1" role="dialog" aria-labelledby="genreModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document" style="max-width: 1200px;">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="genreModalLabel">장르 등록</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body p-0">
                <iframe
                    src="${adminUrl}/music/admin_genre"
                    style="width:100%; height:750px; border:0;"
                    loading="lazy">
                </iframe>
            </div>

        </div>
    </div>
</div>

<!-- 음악 등록 모달 -->
<div class="modal fade" id="musicWriteModal" tabindex="-1" role="dialog" aria-labelledby="musicWriteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document" style="max-width: 1200px;">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="musicWriteModalLabel">음악 등록</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body p-0">
                <iframe
                    src="${adminUrl}/music/write"
                    style="width:100%; height:850px; border:0;"
                    loading="lazy">
                </iframe>
            </div>

        </div>
    </div>
</div>

<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${adminRes}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${adminRes}/js/sb-admin-2.min.js"></script>
<script src="${adminRes}/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="${adminRes}/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<script>
    $(document).ready(function() {
        $('#dataTable').DataTable({
            "pageLength": 10,
            "lengthMenu": [10, 25, 50, 100],
            "ordering": true,
            "searching": true,
            "language": {
                "search": "검색:",
                "lengthMenu": "_MENU_ 개씩 보기",
                "info": "_START_ ~ _END_ / 총 _TOTAL_개",
                "paginate": {
                    "first": "처음",
                    "last": "마지막",
                    "next": "다음",
                    "previous": "이전"
                },
                "zeroRecords": "검색 결과가 없습니다.",
                "infoEmpty": "데이터가 없습니다."
            }
        });
    });
    
    function toggleAudio(audioId, btn) {
        var audio = document.getElementById(audioId);

        if (audio.paused) {
            audio.play();
            btn.innerText = "정지";
        } else {
            audio.pause();
            audio.currentTime = 0;
            btn.innerText = "재생";
        }
    }
</script>

</body>
</html>