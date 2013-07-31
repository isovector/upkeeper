client = "dq9sejip1qpbyipnp5gitc724"
base = "http://www.beeminder.com/api/v1"

echo = window.echo

class BeeminderSettings extends window.Serializable
	token: null
	goal: null

	constructor: (@token) ->
		root = @
	
		$.ajax base + '/users/santino.json',
			type : "GET" 
			dataType : "json"
			data :
				auth_token : root.token
			
			success  : (res, status, xhr) ->
				root.goal = res.goals[1]
				root.save("test")
				
				obj = Serializable.load(BeeminderSettings, "test")
				obj.verify()
				
			error    : (xhr, status, err) ->
			complete : (xhr, status) ->
	
	verify: () ->
		echo @goal

window.BeeminderSettings = BeeminderSettings