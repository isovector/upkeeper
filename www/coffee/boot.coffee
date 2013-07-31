files = [ "library", "beeminder", "app" ]

attach = (url) ->
    script = document.createElement "script"
    script.src = url
    ($ "body").append script

$ ->
    attach ("coffee/" + url + ".js") for url in files
