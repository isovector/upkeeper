window.echo = (params...) ->
    $(".output").html ($ "<div></div>").html params.toString()
    
    
window.__functionCache = { }
window.cache = (name, func) -> __functionCache[name] ?= func

class window.Serializable
    onResume: null

    @load: (constructor, name, defaultArgs...) ->
        try
            object = JSON.parse localStorage[name]
            object.__proto__ = constructor.prototype
            object
        catch error
            new constructor defaultArgs...

    save: (name) -> localStorage[name] = JSON.stringify @

class window.Errors 
    @declare: (name) -> Errors[name] = name
    
    
window.writeObject = (name, value) ->
    localStorage[name] = JSON.stringify value
    
window.loadObject = (name, defaultResult) ->
    try
        JSON.parse localStorage[name]
    catch error
        defaultResult
