files = [ "library", "beeminder", "app" ]

attach = (url) ->
	script = document.createElement "script"
	script.src = url
	($ "body").append script

$ ->
	attach ("upkeeper/" + url + ".js") for url in files
