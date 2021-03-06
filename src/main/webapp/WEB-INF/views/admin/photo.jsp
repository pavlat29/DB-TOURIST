<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/resources/vendor/bootpag/jquery.bootpag.min.js"></script>
<script>
    $(function () {
        $(".fancybox").fancybox({
            openEffect: "none",
            closeEffect: "none"
        });
    });
    function setCover(id) {
        $('#coverId').val(id);
        $('#coverForm').submit();
    }
</script>
<form method="post" id="coverForm" action="/admin/${objectName}/setCover">
    <input type="hidden" name="coverId" id="coverId" value="" />
    <input type="hidden" name="${objectName}Id" id="${objectName}Id" value="${object.id}" />
</form>

<link rel="stylesheet" href="/resources/vendor/fancybox/jquery.fancybox.min.css" media="screen">
<script src="/resources/vendor/fancybox/jquery.fancybox.min.js"></script>

<div class="col-md-12" style="margin-bottom: 15px;">
    <c:if test="${!empty success}">
        <div class="msg-wrapper alert alert-success alert-styled-left alert-arrow-left alert-bordered">
            <button type="button" class="close" data-dismiss="alert"><span>×</span><span class="sr-only">Закрыть</span>
            </button>
                ${success}
        </div>
    </c:if>
    <a href="/admin/${objectName}" class="btn btn-default" style="text-align: center">${backBtnText}</a>
    <a href="/admin/${objectName}/add" class="btn btn-primary" style="text-align: center">Добавить ${objectTitle}</a>
    <a href="#" data-toggle="modal" data-target="#upload_modal" class="btn btn-primary" style="text-align: center">Добавить
        фотографии в альбом</a>
</div>

<div class="col-md-12">
    <div class="row">
        <c:if test="${fn:length(object.photos) == 0}">
            <div class="no-info">
            Нет фотографий
            </div>
        </c:if>
        <c:forEach var="p" items="${object.photos}" varStatus="i">
            <c:set var="photosCount" scope="page" value="16"/>
            <c:set var="totalPages" scope="page" value="${fn:length(object.photos) / photosCount}"/>
            <fmt:formatNumber var="page" value="${(i.index / photosCount) + 1}" maxFractionDigits="0"/>
            <c:set var="newPage" scope="page" value="${i.index % photosCount}"/>
            <c:if test="${newPage == 0}">
            <div id="page${page}" style="${i.index > 0 ? 'display:none' : ''}" class="photo-page">
            </c:if>

            <div class="col-md-4 portfolio-item">
                <a class="thumbnail photo-card fancybox" rel="ligthbox" href="/photo?name=${p.file}" style="margin-bottom: 0px;">
                    <img class="img-responsive" src="/photo?name=${p.file}">
                </a>

                <a class="fancybox-close" data-toggle="modal" data-target="#remove_modal"
                   data-id="${p.file}" style="z-index: 0;right: 0px;top: -15px;"></a>


                    <c:if test="${p.id == object.cover.id}">
                        <span style="display: block;text-align: center">главное фото</span>
                    </c:if>
                    <c:if test="${p.id != object.cover.id}">
                        <a onclick="setCover(${p.id});" href="javascript:void(0)" style="display: block;text-align: center">сделать главным</a>
                    </c:if>

            </div>
            <c:if test="${newPage == photosCount - 1 || fn:length(object.photos) == (i.index + 1)}">
                </div>
            </c:if>
        </c:forEach>
    </div>
</div>


<script>
    $(function () {
        document.getElementById('files').addEventListener('change', onFileSelect, false);
        document.getElementById('uploadButton').addEventListener('click', function () {
            startUpload("/admin/${objectName}/upload", ${object.id});
        }, false);

        $('#pagination-here').bootpag({
            total: ${(totalPages+(1-(totalPages%1))%1)},
            page: 1,
            leaps: true
        }).on("page", function (event, num) {
            $('.photo-page').hide();
            $('#page' + num).show();
            $(window).scrollTop($(document).height());
        });
        $('#remove_modal').on('show.bs.modal', function (e) {
            var id = $(e.relatedTarget).data('id');
            $(this).find(".remove-btn").attr("onclick", "deletePicture('" + id + "')");
        });
    });

</script>
<div class="col-md-12">
    <p id="pagination-here"></p>
</div>

<div id="upload_modal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h5 class="modal-title">Загрузка фотографий</h5>
            </div>
            <form>
                <div class="modal-body">
                    <div class="progress" style="margin-bottom:0px">
                        <div class="progress-bar progress-bar-striped active" role="progressbar" id='bar'
                             aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:0%">
                        </div>
                    </div>
                    <output id="selectedFiles"></output>
                </div>

                <div class="modal-footer">
                 <span class="btn btn-default btn-file">
                        Выберите файлы <input type="file" id="files" accept="image/jpg,image/png,image/jpeg" multiple
                                              style="margin-bottom: 20px"/>
                 </span>
                    <button type="button" class="btn btn-primary" id="uploadButton" disabled>Загрузить</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="remove_modal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h5 class="modal-title">Подтверждение удаления</h5>
            </div>

            <div class="modal-body">
                Вы действительно хотите удалить это фото?
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary remove-btn" data-dismiss="modal">Удалить</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Отмена</button>
            </div>
        </div>
    </div>
</div>