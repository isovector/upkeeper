window.angular.module("upkeeper", []).directive 'eatClick', 
    () ->
        (scope, element, attrs) -> 
            $(element).click () ->
                event.stopPropagation()
