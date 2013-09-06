client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

class window.Beeminder extends Serializable
    token: null
    username: null
    goals: null
    currentGoal: null
    datapoints: null
    
    
    constructor: (@token) ->
    
    call: (url, success, payload, error) ->
        method = if payload? then 'POST' else 'GET'
        payload = payload ? {}
        payload.auth_token = @token
    
        $.ajax "#{base}#{url}",
            type: method
            dataType: 'json'
            data: payload
            
            success: success
            error: error
            complete: (xhr, status) =>
            
    init: (success) ->
        if !@username?
            @call '/users/me.json', 
                (user) =>
                    {@username, @goals} = user
                    @datapoints = { }
                    
                    @save "beeminder"
                    
                    success?()
        else success?()

    selectGoal: (slug, success) -> 
        @call "/users/me/goals/#{localStorage.goal}.json",
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
                
                if !@datapoints[slug]
                    @datapoints[slug] = { }
                
                success? @currentGoal.valid

    constructTimestamp: ->
        Date.now()/1000|0
        
    addData: (task, count = 1) ->
        slug = "upkeep"
        
        comment = task.text
        comment += " x#{count}" if count != 1
        
        @call "/users/me/goals/#{slug}/datapoints.json",
            (datapoint) =>
                alert "pushed #{task.points} to #{slug}"
            , 
            {
                timestamp: @constructTimestamp()
                value: task.points * count
                comment: comment
            },
            () =>
                alert "failed to connect to beeminder"
            

    pushData: (slug, success) ->
        now = @constructTimestamp()
        data = @datapoints[slug]
        
        score = 0
        keys = [ ]
        for date, point of data when date < now
            score += point
            keys.push date
        
        if score > 0
            @call "/users/me/goals/#{slug}/datapoints.json",
                (datapoint) =>
                    data[key] = null for key in keys
                    alert "pushed #{score} to #{slug}"
                    success? score, slug
                , 
                {
                    timestamp: now
                    value: score
                }