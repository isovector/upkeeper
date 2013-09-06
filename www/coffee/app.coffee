$ ->
    window.bee = Serializable.load Beeminder, "beeminder", localStorage.token

    bee.init () ->
        for goal in bee.goals
            element = new Templates.GoalOption goal
            ($ ".goals").append element.dom
        
        bee.selectGoal localStorage.goal, cache "test", (valid) ->
            echo "daily rate is #{bee.currentGoal.dailyRate}" if valid
            echo "invalid goal" unless valid

    ($ ".goals").on "change", (event) ->
        sender = event.currentTarget
        localStorage.goal = ($ ":selected", sender).text()
        
        bee.selectGoal localStorage.goal, cache "test"
        
    offset = 0
    
    taskDom = $ ".options"
    taskDom.append (new Templates.Option "submit score",
        ->
            bee.pushData "upkeep-test"
    ).dom
        
    tokenDom = $ ".token"
    tokenDom.val localStorage.token if localStorage.token?
    
    tokenDom.on "change", (event) -> localStorage.token = tokenDom.val()
