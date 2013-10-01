window.TaskCtrl = ($scope) -> 
    $scope._init = ->
        @items = [ ]
        @panelVisible = false
        @deleteMode = false
        @tasks = loadObject "TaskCtrl.tasks", [ ]
        
        @submit = (task) ->
            if bee?
                count = if task.countable then prompt("how many did you do?", "1") else 1
                bee.addData task, count if count != null
        
        @addItem = () ->
            @items.push { comment: "", points: 1, slug: "upkeeper" }
            
        @resetItems = () ->
            @items = [ ]
            @addItem()
        @resetItems()
        
        @newTask = () ->
            items = ({ points: item.points, slug: item.slug } for item in @items)
            @tasks.push { comment: @newName, countable: @newCountable, items: items }
            @resetItems()
            
            writeObject "TaskCtrl.tasks", @tasks
            
            @newName = @newCountable = ""
            @panelVisible = @batchAdd
            
        @deleteTasks = () ->
            return unless confirm("are you sure you want to delete these tasks?")
            
            @tasks = (task for task in @tasks when task.toDelete isnt true)
            writeObject "TaskCtrl.tasks", @tasks
            
            @toggleDelete()
            
        @togglePanel = () -> @panelVisible = !@panelVisible
        @toggleDelete = () -> @deleteMode = !@deleteMode
        
        
    
    
    $scope._init()