$ ->
    bee = Serializable.load Beeminder, "beeminder", localStorage.token

    bee.init () ->
        for goal in bee.goals
            element = document.createElement "option"
            element.text = goal
            element.selected = true if goal == localStorage.goal
            
            ($ ".goals").append element
        
        bee.selectGoal localStorage.goal, cache "test", (valid) ->
            echo "daily rate is #{bee.currentGoal.dailyRate}" if valid
            echo "invalid goal" unless valid

    ($ ".goals").on "change", (event) ->
        sender = event.currentTarget
        localStorage.goal = ($ ":selected", sender).text()
        
        bee.selectGoal localStorage.goal, cache "test"
        
    tokenDom = $ ".token"
    tokenDom.val localStorage.token if localStorage.token?
    
    tokenDom.on "change", (event) -> localStorage.token = tokenDom.val()