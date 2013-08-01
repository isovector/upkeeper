window.echo = (params...) ->
    $(".output").append $("<div></div>").html params.toString()

class window.Serializable
    onResume: null

    @load: (constructor, name, defaultArgs...) ->
        if localStorage[name]?
            object = JSON.parse(localStorage[name])
            object.__proto__ = constructor.prototype
            object
        else
            new constructor defaultArgs...

    save: (name) ->
        localStorage[name] = JSON.stringify(@)
