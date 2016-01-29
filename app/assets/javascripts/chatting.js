$(document).ready(function(){


    var ws = null;
    var current_user_id = document.getElementById("login_user_id").value;
    ws = new WebSocket("ws://192.168.1.88:8086?user_id="+current_user_id);
    ws.onopen = function(){
        console.log("Connection is opened");
    };

    ws.onclose = function(){
        console.log("Connection is closed");
        console.log("socket.readyState", ws.readyState);
    };

    ws.onmessage = function(msg){
        console.log("message", msg.data);
        //document.getElementById("display").innerHTML = msg.data;
        var data = msg.data;
        var json = JSON.parse(msg.data)
        //alert(json["receiver_id"]+"  "+ json["user_id"]);
        $("#messagesBox"+json["user_id"]).append("<div style ='float:left; text-align:left;' class = 'chatMsg'><span class ='innerChatMsgFrd'>"+json["message"]+"</span></div>")
    };


    /*$("#addUserToChat").click(function()
    {
        alert("add");
    });

    $(".accorItem").click(function()
    {
       var userId = $(this).attr("user_id");
        
    });*/

    $(".send_message").click(function(){
        var user_id = $(this).attr("user_id");
        var receiver_id = user_id.substring(7);
        var current_user_id = document.getElementById("login_user_id").value;
        var message = document.getElementById("messageText"+receiver_id).value;
        if(message.trim() == "")
        {
            alert("Please enter message to send.")
        }
        else {
            //alert(current_user_id +"  "+receiver_id+"   "+message);
            var json = '{"user_id": "' + current_user_id + '", "receiver_id": "' + receiver_id + '", "message": "' + message + '", "category": "SEND"}';
            $("#messagesBox" + receiver_id).append("<div style ='float:right; text-align:right;' class = 'chatMsg'><span class ='innerChatMsgSelf'>" + message + "</span></div>")
            ws.send(json);
        }
    });

    $("#logout").click(function(){
       var current_user_id = document.getElementById("login_user_id").value;
        var json = '{"user_id":"'+current_user_id+'", "category": "LOGOUT"}'
        ws.close();
        $.ajax({
            type: 'POST',
            url: 'users/logout',
            data:{
                'user_id': current_user_id
            },
            success: function(response){
                if(response.success)
                {
                    location.reload();
                }
                else
                {
                    alert(response.message);
                    location.reload();
                }
            },
            error: function(){
                alert("Internal server error, please try again.")
                //location.reload();
            }
        });
        //ws.send(json);
    });
});

function userLogin()
{
    var email = document.getElementById("loginEmail").value;
    var password = document.getElementById("loginPassword").value;
    if(email == "" || password == "")
    {
        alert("Enter email and password");
    }
    else
    {
        $.ajax({
           type: "POST",
            url: "/users/login",
            data:{
                'email': email,
                'password': password
            },
            success: function(response){
                if(response.success)
                {
                    location.reload();
                }
                else
                {
                    alert(response.message);
                    //location.reload();
                }
            },
            error: function(){
                alert("Internal server error, please try again.")
            }
        });
    }
}

function userRegister()
{
    var name = document.getElementById("registerName").value;
    var email = document.getElementById("registerEmail").value;
    var password = document.getElementById("registerPassword").value;
    if(email == "" || password == "" || name == "")
    {
        alert("All fields are compulsory, Please fill all fields.");
    }
    else
    {
        $.ajax({
            type: "POST",
            url: "/users/create",
            data:{
                'name': name,
                'email': email,
                'password': password
            },
            success: function(response){
                if(response.success)
                {
                    location.reload();
                }
                else
                {
                    alert(response.message);
                    //location.reload();
                }
            },
            error: function(){
                alert("Internal server error, please try again.")
            }
        });
    }
}