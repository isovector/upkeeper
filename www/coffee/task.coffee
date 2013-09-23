window.TaskCtrl = ($scope) -> 
    $scope._init = ->
        @icons = [ ]
        @panelVisible = false
        @deleteMode = false
        @tasks = loadObject "TaskCtrl.tasks", [ ]
        
        
        @submit = (task) ->
            if bee?
                count = if task.countable then prompt("how many did you do?", "1") else 1
                bee.addData task, count
            
            
        @newTask = () ->
            @tasks.push { text: @newText, points: @newPoints, countable: @newCountable, slug: @newSlug }
            writeObject "TaskCtrl.tasks", @tasks
            
            @newText = @newPoints = @newCountable = ""
            @panelVisible = @batchAdd
            
            
        @deleteTasks = () ->
            return unless confirm("are you sure you want to delete these tasks?")
            
            @tasks = (task for task in @tasks when task.toDelete isnt true)
            writeObject "TaskCtrl.tasks", @tasks
            
            @toggleDelete()
            
            
        @togglePanel = () -> @panelVisible = !@panelVisible
        @toggleDelete = () -> @deleteMode = !@deleteMode
    
    
    $scope._init()