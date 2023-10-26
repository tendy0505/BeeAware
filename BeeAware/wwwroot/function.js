
currentUser = null

window.onload = function () {
    checkLogin()
    //switchPage('mainPage')
    //switchInnerPage('mainInnerPage')
}

document.getElementById("login-form").addEventListener("submit", function (event) {
    login(event);
})

document.getElementById("register-form").addEventListener("submit", function (event) {
    register(event);
})

document.getElementById("UploadModuleForm").addEventListener("submit", function (event) {
    uploadModule(event);
})


function checkLogin() {
    fetch("/api/User/checkLogin",{})
        .then(response => {
            response.json().then(data => {
                if (response.status == 202) {
                    currentUser = data[0]
                    updateUserTab(currentUser)
                    switchPage('mainPage')
                    switchInnerPage('mainInnerPage')
                    ModuleCheck();
                    ModuleList();
                    return
                } else if (response.status == 204) {
                 
                } else {
                    alert("disconnected")
                }
            })
        }
        ).catch(function (err) {
            alert("disconnected")
        })
    switchPage('loginPage')
}

function setActiveLink(linkId) {
    var links = document.querySelectorAll('.sidebar a');
    links.forEach(function (link) {
        link.classList.remove('active');
    });
    document.getElementById(linkId).classList.add('active');
}

function switchPage(name) {
    setActiveLink(name);
    var pages = document.getElementsByClassName("pages");
    var shownPage = document.getElementById(name);
    for (var i = 0; i < pages.length; i++) {
        pages[i].style.display = "none";
    }
    shownPage.style.display = "block";
}

function switchInnerPage(name) {
    setActiveLink(name);
    var pages = document.getElementsByClassName("innerPages");
    var shownPage = document.getElementById(name);
    for (var i = 0; i < pages.length; i++) {
        pages[i].style.display = "none";
    }
    shownPage.style.display = "block";
    var clickedLinks = document.querySelectorAll('.switch-link');
    clickedLinks.forEach(function (link) {
        link.classList.remove('active');
    });
    var clickedLink = document.querySelector('.switch-link[onclick="switchInnerPage(\'' + name + '\')"]');
    clickedLink.classList.add('active');
}




function login(event) {
    event.preventDefault();
    event.stopImmediatePropagation();
    var email = document.getElementById ("login-email").value
    var password = document.getElementById("login-password").value

    const data = JSON.stringify({
        'UserName': email,
        "Password": password,
        "UserPoints": 0,
        "PostDate": "",
    })
    fetch("/api/User/login", {
        method: 'POST',
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
        body: data,
    })
        .then(response => {
            response.json().then(data => {
                if (response.status == 202) {
                    currentUser = data[0]
                    updateUserTab(currentUser)
                    switchPage('mainPage')
                    switchInnerPage('mainInnerPage')
                    ModuleCheck();
                    ModuleList();
                } else if (response.status == 404) {
                    alert("user not found");
                } else {
                    alert("wrong password")
                }
            })
        }
        ).catch(function (err) {

        })
};

function logout(event) {

    fetch("/api/User/logout", {
        method: 'GET',
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' })
    })
        .then(response => {
            document.getElementById("switchInnerPageButtons").innerHTML= '<a class="switch-link active" onclick="switchInnerPage(\'mainInnerPage\')">Main Page</a> '
        }
        ).catch(function (err) {

        })
};

function register(event) {
    event.preventDefault();
     var email = document.getElementById ("register-email").value
     var password = document.getElementById("register-password").value
     const data = JSON.stringify({
         'UserName': email,
         "Password": password,
         "UserPoints": 0,
         "PostDate": "",
     })
     fetch("/api/User/register", {
         method: 'POST',
         referer: 'about:client',
         credentials: 'same-origin',
         headers: new Headers({ 'content-type': 'application/ json' }),
         body: data,
     })
         .then(function (response) {
             response.json().then(data => {
                 if (response.status == 201) {
                     switchPage("loginPage")
                 } else {
                     window.alert("Failed to register")
                 }
             })
         }
         ).catch(function (err) {
             window.alert("Something wrong at front-end")
         })
 };

function ModuleCheck(){
    fetch("/api/Module/Check", {
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
    })
        .then(function (response) {
            if (response.status == 200) {
                response.json()
                    .then(data => {
                        var innerPagesDiv = document.getElementById("innerPagesDiv");
                        var switchInnerPageButtons = document.getElementById("switchInnerPageButtons")


                        for (var i = 0; i < data.length; i++) {
                            innerPagesDiv.insertAdjacentHTML("beforeend", data[i]);
                            var newInnerPage = document.getElementsByClassName("innerPages")
                            console.log(newInnerPage)
                            switchInnerPageButtons.insertAdjacentHTML("beforeend", " <a class='switch-link' onclick=" + '"' + "switchInnerPage('" + newInnerPage[newInnerPage.length - 3].id + "')" + '"' + " >" + newInnerPage[newInnerPage.length - 3].getAttribute("nameonbutton") +"</a>")
                        }
           
                        var scripts = document.getElementsByTagName("script")
                        for (i = 0; i < scripts.length-2; i++) {
                            const importScript = document.createElement("script")
                            importScript.setAttribute("src", scripts[i].src);
                            scripts[i].remove();
                            document.head.appendChild(importScript)
                        }
                    })
            } else {

            }

        }
        ).catch(function (err) {

        })
}


function ModuleList() {
    fetch("/api/Module/List", {
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
    })

        .then(function (response) {
            if (response.status == 200) {
                response.json()
                    .then(data => {
                        moduleList = document.getElementById("moduleList")
                        for (var i = 0; i < data.length; i++) {
                            moduleList.insertAdjacentHTML("beforeend", "<div class= 'card' ><div class='card-header'>" + data[i].ModuleCode + "<button type = 'button' class='btn btn-danger float-end' onclick =" + '"ModuleDelete(' + "'" + data[i]._Module + "'"+')"'+">Delete</button> </div><div class='card-body'>" + data[i].Description + "</div> </div> ")
                        }
                    })
            } else {

            }

        }
        ).catch(function (err) {

        })
}

function ModuleDelete(name) {
    const data = JSON.stringify({
        '_Module': name,
        "ModuleCode": "",
        "Description": "",
        "SecurityLevel": 0,
    })
    fetch("/api/Module/Delete", {
        method: 'POST',
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
        body: data,
    })
        .then(function (response) {
            if (response.status == 200) {
                response.json()
                    .then( ()=> {
                        moduleList = document.getElementById("moduleList")
                        moduleList.innerHTML = '<h1 class="text-center pb-4"><img src="images/Bee.png" width="100" height="100" alt="Bee Aware Platform">Delete Plugins</h1>'
                        ModuleList()
                    })
            } else {

            }

        }
        ).catch(function (err) {

        })
}







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

function updateUserTab(userName) {
    document.getElementById("UserTab").innerHTML = '<a role="button" class="btn btn-secondary dropdown-toggle dropUpStyle" data-bs-toggle="dropdown" aria-expanded="false"><img src = "images/portrait.png" alt = "" width = "32" height = "32" class="rounded-circle me-2" > ' + userName + '</a > <ul class="dropdown-menu" > <li><a class="dropdown-item" onclick="switchPage(\'setUpPage\') ; switchInnerPage(\'uploadPage\')">Set up</a></li> <li><a class="dropdown-item" onclick="switchPage(\'loginPage\');logout();">Sign out</a></li></ul > '
}

function toggleElement() {
    var element = document.querySelector('.subNav');

    if (element) {
        var style = window.getComputedStyle(element);

        if (style.display === 'none' || style.display === '') {
            element.style.display = 'block';
        } else {
            element.style.display = 'none';
        }
    }
}

