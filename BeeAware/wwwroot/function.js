
window.onload = function(){
    ModuleCheck();
    ModuleList();
    switchPage('loginPage')
}

document.getElementById("login-form").addEventListener("submit", function (event) {
    login(event);
})

document.getElementById("register-form").addEventListener("submit", function (event) {
    register(event);
})




function switchPage(name) {
    var pages = document.getElementsByClassName("pages");
    var shownPage = document.getElementById(name);
    for (var i = 0; i < pages.length; i++) {
        pages[i].style.display = "none";
    }
    shownPage.style.display = "block";
}

function switchInnerPage(name) {
    var pages = document.getElementsByClassName("innerPages");
    var shownPage = document.getElementById(name);
    for (var i = 0; i < pages.length; i++) {
        pages[i].style.display = "none";
    }
    shownPage.style.display = "block";
}



function login(event) {
    event.preventDefault();
    event.stopImmediatePropagation();
    var email = document.getElementById ("login-email")
    var password = document.getElementById("login-password")

    const data = JSON.stringify({
        'id': parseInt(0),
        "email": email.value,
        "group": email.value,
        "password": password.value,
    })
    fetch("/api/User/login", {
        method: 'POST',
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
        body: data,
    })
        .then(function (response) {
            if (response.status == 202) {
                switchPage('mainPage')
                switchInnerPage('mainInnerPage')

            } else if (response.status == 404) {
                alert("user not found");
            } else {
                alert ("wrong password")
            }

        }
        ).catch(function (err) {

        })
};

function register(event) {
    event.preventDefault();
     var email = document.getElementById ("register-email")
     var password = document.getElementById("register-password")
    
    
     const data = JSON.stringify({
         'id': parseInt(0),
 
         "email": email.value,
         "group": "",
 
         "password": password.value,
     })
     fetch("/api/User/register", {
         method: 'POST',
         referer: 'about:client',
         credentials: 'same-origin',
         headers: new Headers({ 'content-type': 'application/ json' }),
         body: data,
     })
         .then(function (response) {
             if (response.status == 201) {
                 switchPage("loginPage")
             } else {
                
             }
 
         }
         ).catch(function (err) {
 
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
                            switchInnerPageButtons.insertAdjacentHTML("beforeend", " <a onclick=" + '"' + "switchInnerPage('" + newInnerPage[newInnerPage.length - 1].id + "')" +'"' + " >" + newInnerPage[newInnerPage.length - 1].id +"</a>")
                        }
                        
                        
                        var scripts = document.getElementsByTagName("script")
                        
                        for (i = 0; i < scripts.length; i++) {
                            const importScript = document.createElement("script")
                            importScript.setAttribute("src", scripts[i].src);
                            scripts[i].remove();
                            document.head.appendChild(importScript)
                        }

                        var scripts = document.getElementsByTagName("script")
                        for (i = 0; i < scripts.length; i++) {
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
                            moduleList.insertAdjacentHTML("beforeend", "<div class= 'card' ><div class='card-header'>" + data[i].Name + "<button type = 'button' class='btn btn-danger float-end' onclick =" + '"ModuleDelete(' + "'" + data[i].Name + "'"+')"'+">Delete</button> </div><div class='card-body'>" + data[i].Description + "</div> </div> ")
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
        'description': "",
        "id": 0,
        "name": name,
        "tableUse": "",
    })
    console.log(data)
    fetch("/api/Module/Delete", {
        method: 'POST',
        referer: 'about:client',
        credentials: 'same-origin',
        headers: new Headers({ 'content-type': 'application/ json' }),
        body: data,
    })
        .then(function (response) {
            console.log(name)
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
