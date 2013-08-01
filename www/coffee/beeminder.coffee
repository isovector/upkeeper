client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

class window.Beeminder extends Serializable
    token: null
    username: null
    goals: null
    currentGoal: null
    
    
    constructor: (@token) ->
    
    call: (url, success, payload) ->
        payload = payload ? {}
        payload.auth_token = @token
    
        $.ajax base + url,
            type: 'GET'
            dataType: 'json'
            data: payload
            
            success: success
            error: (xhr, status, err) =>
            complete: (xhr, status) =>
            
    init: (success) ->
        if !@username?
            @call '/users/me.json', 
                (user) =>
                    {@username, @goals} = user
                    @save "beeminder"
                    
                    success?()
        else success?()

    selectGoal: (slug, success) -> 
        @call "/users/#{@username}/goals/#{localStorage.goal}.json",
            (goal) =>
                @currentGoal = 
                    slug: slug
                    response: goal
                    valid: goal.goal_type == "hustler"
                    dailyRate: goal.rate / 
                        switch goal.runits
                            when "y" then 365
                            when "m" then 30
                            when "w" then 7
                            when "h" then 1 / 24
                
                success? @currentGoal.valid