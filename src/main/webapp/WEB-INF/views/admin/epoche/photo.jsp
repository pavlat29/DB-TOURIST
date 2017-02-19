<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="/resources/vendor/bootpag/jquery.bootpag.min.js"></script>
<div class="col-md-12" style="margin-bottom: 15px;">
<a href="#" data-toggle="modal" data-target="#upload_modal" class="btn btn-primary" style="text-align: center">Добавить фотографии в альбом</a>
</div>
<c:forEach var="p" items="${epoch.photos}" varStatus="i">
    <c:set var="photosCount" scope="page" value="16"/>
    <c:set var="totalPages" scope="page" value="${fn:length(epoch.photos) / photosCount}"/>
    <fmt:formatNumber var="page" value="${(i.index / photosCount) + 1}" maxFractionDigits="0" />
    <c:set var="newPage" scope="page" value="${i.index % photosCount}"/>
    <c:if test="${newPage == 0}">
        <div id="page${page}" style="${i.index > 0 ? 'display:none' : ''}" class="photo-page">
    </c:if>
        <div class="col-lg-3 col-md-4 col-xs-6 thumb">
            <a class="thumbnail photo-card" href="#">
                <img class="img-responsive" src="/photo?name=thumb_${p.file}" alt="" style="width:230px;height: 145px;">
                <div class="photo-del" title="Удалить фото" data-toggle="modal" data-target="#remove_modal" data-id="${p.file}">x</div>
            </a>
        </div>
    <c:if test="${newPage == photosCount - 1 || fn:length(epoch.photos) == (i.index + 1)}">
        </div>
    </c:if>
</c:forEach>

<script>
    $(function () {
        document.getElementById('files').addEventListener('change', onFileSelect, false);
        document.getElementById('uploadButton').addEventListener('click', function () {
            startUpload("/admin/epoches/upload", ${epoch.id});
        }, false);

        $('#pagination-here').bootpag({
            total: ${(totalPages+(1-(totalPages%1))%1)},
            page: 1,
            leaps: true
        }).on("page", function(event, num){
            $('.photo-page').hide();
            $('#page' + num).show();
            $(window).scrollTop($(document).height());
        });
        $('#remove_modal').on('show.bs.modal', function(e) {
            var id = $(e.relatedTarget).data('id');
            $(this).find(".remove-btn").attr("onclick", "deletePicture('"+id+"')");
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
                        Выберите файлы <input type="file" id="files" accept="image/jpg,image/png,image/jpeg" multiple style="margin-bottom: 20px"/>
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