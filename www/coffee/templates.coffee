window.Templates = { }
class Component
    constructor: (html, init, @destructor) ->
        @dom = $ html
        init? @dom
    
    destroy: ->
        @destructor? @dom
        @dom.remove()
        @dom = null
        
    get: (selector) ->
        $ selector, @dom


class Templates.GoalOption extends Component
    constructor: (name) -> 
        super \
        """
        <option></option>
        """,
        
        (dom) =>
            dom.html name
            dom.attr "selected", "selected" if localStorage.goal == name
            
            
class Templates.Task extends Component
    constructor: (task) ->
        super \
        """
        <li>
            <input type="button" value="+" class="add" />
            <input type="button" value="-" class="sub" />
            <span class="name" />
        </li>
        """,
        
        =>
            (@get ".name").html task
            (@get ".add").on "click", =>
                alert task
            (@get ".sub").on "click", =>
                @destroy()