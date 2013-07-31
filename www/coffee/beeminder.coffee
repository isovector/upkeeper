client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

class window.Beeminder
    @token: null
    @username: null
    @goals: null
    
    constructor: (@token) ->
    
    call: (url, success, payload) ->
        payload = payload ? {}
        payload.auth_token = @token
    
        $.ajax base + url,
            type: "GET" 
            dataType: "json"
            data: payload
            
            success: success
            error: (xhr, status, err) =>
            complete: (xhr, status) =>
            
    init: (success) ->
        @call '/users/me.json', 
            (user) =>
                @username = user.username
                @goals = user.goals
                success?(@)
