$ ->
    taskDom = $ ".options"
    taskDom.append (new Templates.Option "submit score",
        ->
            bee.pushData "upkeep-test"
    ).dom
    