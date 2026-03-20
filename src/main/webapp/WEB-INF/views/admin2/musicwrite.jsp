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
            max-width: 1000px;
            margin: 40px auto;
        }

        .required-mark {
            color: #e74a3b;
            margin-left: 4px;
        }

        .form-section-card {
            border: 1px solid #e3e6f0;
            border-radius: 16px;
            background: #fff;
            padding: 18px;
            box-shadow: 0 0.15rem 1rem 0 rgba(58,59,69,.08);
        }

        .picker-box {
            border: 1px solid #d1d3e2;
            border-radius: 14px;
            padding: 16px;
            background: #fff;
        }

        .picker-title {
            font-weight: 700;
            margin-bottom: 12px;
            color: #3a3b45;
            font-size: 0.95rem;
        }

        .chip-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .chip-btn {
            border: 1.5px solid #b7b9cc;
            background: #fff;
            color: #3a3b45;
            border-radius: 999px;
            padding: 10px 16px;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.15s ease-in-out;
            outline: none !important;
            box-shadow: none !important;
        }

        .chip-btn:hover {
            border-color: #4e73df;
            color: #4e73df;
            background: #f8faff;
        }

        .chip-btn.active {
            background: #dbe8ff;
            border-color: #4e73df;
            color: #1f3fa6;
            font-weight: 600;
        }

        .chip-check {
            display: none;
            font-size: 0.9rem;
            font-weight: 700;
        }

        .chip-btn.active .chip-check {
            display: inline-block;
        }

        .selected-wrap {
            border: 1px solid #d1d3e2;
            border-radius: 14px;
            padding: 14px 16px;
            background: #f8f9fc;
        }

        .selected-title {
            font-weight: 700;
            margin-bottom: 10px;
            color: #3a3b45;
        }

        .selected-badge {
            display: inline-flex;
            align-items: center;
            background: #4e73df;
            color: #fff;
            padding: 7px 12px;
            border-radius: 999px;
            margin-right: 8px;
            margin-bottom: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            gap: 6px;
        }

        .selected-empty {
            color: #858796;
            font-size: 0.92rem;
        }

        .nice-select {
            height: auto;
            min-height: 48px;
            border-radius: 14px;
            border: 1px solid #d1d3e2;
            padding: 10px 14px;
            background-color: #fff;
            box-shadow: none !important;
        }

        .nice-select:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78,115,223,.15) !important;
        }

        .section-label {
            font-weight: 700;
            color: #3a3b45;
            margin-bottom: 8px;
        }

        .page-title {
            font-weight: 700;
            color: #2e2e2e;
        }

        .sub-text {
            color: #858796;
            font-size: 0.95rem;
        }

        .textarea-nice {
            border-radius: 14px;
            border: 1px solid #d1d3e2;
            padding: 12px 14px;
            resize: vertical;
            box-shadow: none !important;
        }

        .textarea-nice:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78,115,223,.15) !important;
        }

        .file-box {
            border: 1px dashed #b7b9cc;
            border-radius: 14px;
            padding: 16px;
            background: #f8f9fc;
        }

        .music-submit-wrap {
            text-align: right;
        }
    </style>
</head>
<body>

<div class="container-fluid write-wrap">

    <div class="mb-4">
        <h2 class="page-title">음악 등록</h2>
        <div class="sub-text">노래 정보와 장르를 등록합니다.</div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h5 class="m-0 font-weight-bold text-primary">등록 폼</h5>
        </div>

        <div class="card-body">
            <form action="${adminUrl}/music/write" method="post" enctype="multipart/form-data">

                <div class="form-section-card mb-4">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label class="section-label">
                                아티스트
                                <span class="required-mark">*</span>
                            </label>
                            <select name="artistId" class="form-control nice-select" required>
                                <option value="">아티스트를 선택하세요</option>
                                <c:forEach var="artist" items="${artistList}">
                                    <option value="${artist.artistId}">${artist.artistName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group col-md-6">
                            <label class="section-label">
                                앨범
                                <span class="required-mark">*</span>
                            </label>
                            <select name="albumId" class="form-control nice-select" required>
                                <option value="">앨범을 선택하세요</option>
                                <c:forEach var="album" items="${albumList}">
                                    <option value="${album.albumId}">${album.albumTitle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group mb-0">
                        <label class="section-label">
                            노래 제목
                            <span class="required-mark">*</span>
                        </label>
                        <input type="text" name="songTitle" class="form-control nice-select" required>
                    </div>
                </div>

                <div class="form-section-card mb-4">
                    <div class="form-group mb-0">
                        <label class="section-label">
                            장르 선택
                            <span class="required-mark">*</span>
                        </label>

                        <div class="picker-box">
                            <div class="picker-title">Select genres</div>

                            <div class="chip-list" id="genreChipList">
                                <c:forEach var="genre" items="${genreList}">
                                    <button type="button"
                                            class="chip-btn"
                                            data-genre-id="${genre.genreId}"
                                            data-genre-name="${genre.genreName}">
                                        <span class="chip-check">✓</span>
                                        <span>${genre.genreName}</span>
                                    </button>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="selected-wrap mt-3">
                            <div class="selected-title">선택된 장르</div>
                            <div id="selectedGenreArea"></div>
                        </div>

                        <div id="genreHiddenInputs"></div>
                    </div>
                </div>

                <div class="form-section-card mb-4">
                    <div class="form-group">
                        <label class="section-label">
                            mp3 파일
                            <span class="required-mark">*</span>
                        </label>
                        <div class="file-box">
                            <input type="file" name="songFile" class="form-control-file" accept=".mp3,audio/mpeg" required>
                            <small class="form-text text-muted mt-2">mp3 파일만 업로드 가능합니다.</small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="section-label">상세 설명</label>
                        <textarea name="detail" class="form-control textarea-nice" rows="4"></textarea>
                    </div>

                    <div class="form-group mb-0">
                        <label class="section-label">가사</label>
                        <textarea name="lyrics" class="form-control textarea-nice" rows="8"></textarea>
                    </div>
                </div>

                <div class="music-submit-wrap">
                    <button type="submit" class="btn btn-success px-4">등록</button>
                </div>

            </form>
        </div>
    </div>

</div>

<script src="${adminRes}/vendor/jquery/jquery.min.js"></script>
<script src="${adminRes}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const genreButtons = document.querySelectorAll(".chip-btn");
    const selectedGenreArea = document.getElementById("selectedGenreArea");
    const hiddenInputsArea = document.getElementById("genreHiddenInputs");

    const selectedGenres = new Map();

    function renderSelectedGenres() {
        selectedGenreArea.innerHTML = "";
        hiddenInputsArea.innerHTML = "";

        if (selectedGenres.size === 0) {
            selectedGenreArea.innerHTML = '<span class="selected-empty">선택된 장르가 없습니다.</span>';
            return;
        }

        selectedGenres.forEach((name, id) => {
            const badge = document.createElement("span");
            badge.className = "selected-badge";
            badge.innerHTML = '<span>' + name + '</span><span>×</span>';
            badge.setAttribute("data-genre-id", id);

            badge.addEventListener("click", function () {
                selectedGenres.delete(id);

                const btn = document.querySelector('.chip-btn[data-genre-id="' + id + '"]');
                if (btn) {
                    btn.classList.remove("active");
                }

                renderSelectedGenres();
            });

            selectedGenreArea.appendChild(badge);

            const hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "genreIds";
            hidden.value = id;
            hiddenInputsArea.appendChild(hidden);
        });
    }

    genreButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            const genreId = this.getAttribute("data-genre-id");
            const genreName = this.getAttribute("data-genre-name");

            if (selectedGenres.has(genreId)) {
                selectedGenres.delete(genreId);
                this.classList.remove("active");
            } else {
                selectedGenres.set(genreId, genreName);
                this.classList.add("active");
            }

            renderSelectedGenres();
        });
    });

    renderSelectedGenres();

    const form = document.querySelector("form");
    if (form) {
        form.addEventListener("submit", function (e) {
            if (selectedGenres.size === 0) {
                e.preventDefault();
                alert("장르를 하나 이상 선택하세요.");
            }
        });
    }
});
</script>

</body>
</html>