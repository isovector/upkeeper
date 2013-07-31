window.echo = (params...) ->
    $(".output").append $("<div></div>").html params.toString()

class window.Serializable
    @load: (constructor, name) ->
        object = JSON.parse(localStorage[name])
        object.__proto__ = constructor.prototype
        object

    save: (name) ->
        localStorage[name] = JSON.stringify(@)
