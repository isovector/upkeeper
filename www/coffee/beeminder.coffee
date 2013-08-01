client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

class window.Beeminder extends Serializable
    @token: null
    @username: null
    @goals: null
    @currentGoal:
        slug: null
        title: null
        rate: null
        
    
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
                    @username = user.username
                    @goals = user.goals
                    
                    @save "beeminder"
                    
                    @initGoal(success)
        else
            @initGoal(success)

    initGoal: (success) -> 
        @call "/users/#{@username}/goals/#{localStorage.goal}.json",
            (goal) =>
                @currentGoal.slug = goal.slug
                @currentGoal.title = goal.title
                @currentGoal.rate = goal.rate
                
                switch goal.runits
                    when "y" then @currentGoal.rate /= 365
                    when "m" then @currentGoal.rate /= 30
                    when "w" then @currentGoal.rate /= 7
                    when "h" then @currentGoal.rate *= 24
                
                success?()