window.TaskCtrl = ($scope) -> 
    $scope._init = ->
        @panelVisible = false

        @tasks = loadObject "TaskCtrl.tasks", [ ]
        
        @submit = (task) ->
            count = if task.countable then prompt("how many did you do?", "1") else 1
            bee.addData task, count
            
        @newTask = () ->
            @tasks.push { text: @newText, points: @newPoints, countable: @newCountable }
            writeObject "TaskCtrl.tasks", @tasks
            
            @newText = @newPoints = @newCountable = ""
            @panelVisible = @batchAdd
            
            
        @showPanel = () -> @panelVisible = true
    
    
    $scope._init()