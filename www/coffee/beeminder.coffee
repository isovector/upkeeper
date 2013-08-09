client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

serialize = (obj) ->
    str = []
    str.push (encodeURIComponent key) + "=" + (encodeURIComponent val) for key, val of obj
    str.join "&"

class window.Beeminder extends Serializable
    token: null
    username: null
    goals: null
    currentGoal: null
    datapoints: null
    
    
    constructor: (@token) ->
    
    call: (url, success, payload) ->
        method = if payload? then 'POST' else 'GET'
        payload = payload ? {}
        payload.auth_token = @token
    
        $.ajax "#{base}#{url}?#{serialize payload}",
            type: method
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
        now = new Date()
        now.setHours 0
        now.setMinutes 0
        now.setSeconds 0
        now.setMilliseconds 0
        
        now.getTime()
        
    addData: (slug, score, offset) ->
        now = @constructTimestamp() - offset ? 0
        @datapoints[slug][now] = score
            

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