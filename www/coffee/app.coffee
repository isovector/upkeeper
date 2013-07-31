bee = new Beeminder localStorage.token

bee.init () ->
    for goal in bee.goals
        element = document.createElement "option"
        element.text = goal
        element.selected = true if goal == localStorage.goal
        
        ($ ".goals").append element

$ ->
    ($ ".goals").on "change", (event) ->
        sender = event.currentTarget
        localStorage.goal = ($ ":selected", sender).text()
        
    tokenDom = $ ".token"
    tokenDom.val localStorage.token if localStorage.token?
    
    tokenDom.on "change", (event) ->
        localStorage.token = tokenDom.val()