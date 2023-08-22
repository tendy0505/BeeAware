
document.getElementById("UploadModuleForm").addEventListener("submit", function (event) {
    uploadModule(event);
})




function uploadModule(event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    const formData = new FormData;
    var file = document.getElementById("uploadFile").files[0];
    formData.append('FileName', file.name.substr(0, file.name.lastIndexOf('.')));
    formData.append('file', file);

    fetch("/api/Upload/UploadModule", {
        referer: 'about:client',
        credentials: 'same-origin',
        method: 'POST',
        body: formData
    })
        .then(function (response) {
            if (response.status == 201) {
                response.json()
                    .then(data => {
                        window.alert("uploaded")
                    })
            } else {
                window.alert("failed!!")
            }

        }
        ).catch(function (err) {

        })
};