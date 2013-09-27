client = "dq9sejip1qpbyipnp5gitc724"
base = "https://www.beeminder.com/api/v1"

getSdataScore = (sdata) ->
    sdata.reduce (x, item) ->
        x + item.value
    , 0

window.BeeminderCtrl = ($scope) ->
    $scope._init = ->
        @token = loadObject "Beeminder.token", ""
        @slugs = [ ]
        @authenticated = false
        @data = loadObject "Beeminder.data", { }

        @call = (url, success, payload, error) ->
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
                
        @authenticate = ->
            writeObject "Beeminder.token", @token
            @call '/users/me.json', 
                (user) =>
                    @authenticated = true
                    @slugs = user.goals
                    @$apply()
        @authenticate() unless @token == ""
        
        @constructTimestamp = ->
            Date.now()/1000|0
        
        @getSlugValue = (slug) -> getSdataScore @data[slug]
        
        @addData = (task, count = 1) ->
            slug = task.slug
            @data[slug] = [ ] unless @data[slug]?
            @data[slug].push
                timestamp: @constructTimestamp()
                value: task.points * count
                comment: task.text
        
        @deleteData = (slug, task) ->
            sdata = @data[slug]
            sdata.splice sdata.indexOf(task), 1
            delete @data[slug] if sdata.length == 0

        @pushData = ->
            for slug, sdata of @data
                points = getSdataScore sdata
                continue if points == 0
                
                sdata = 
                    sdata.reduce (x, item) ->
                        x[item.comment] = 0 unless x[item.comment]?
                        x[item.comment] += item.value
                        x
                    ,
                    { }
                
                sdata = ({ comment: comment, value: value } for comment, value of sdata)
                sdata.sort (a, b) -> b.value - a.value
                
                comment = (item.comment for item in sdata).slice(0, 5).join ", "

                do (slug, points) =>
                    @call "/users/me/goals/#{slug}/datapoints.json",
                        (datapoint) =>
                            alert "pushed #{points} to #{slug}"
                            delete @data[slug]
                            @$apply()
                        , 
                        {
                            timestamp: @constructTimestamp()
                            value: points
                            comment: comment
                        },
                        () =>
                            alert "failed to connect to beeminder"
                        
        $(window).bind "beforeunload", () =>
            #@pushData()
            #return "autosaving..." unless Object.keys(@data).length == 0
                    
    window.bee = $scope
    $scope._init()