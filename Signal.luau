local module = {}
module.__index = module

function module.Create(
)
	
	local self = setmetatable(
		{}, module
	)
	self.Connections = {}
	
	return self
end

function module:Connect(
	func : BindableFunction
)
	
	local dictionary = {
		
		Connected = true,
		Function = func,
	}
	
	dictionary.Disconnect = function(
	)
		
		dictionary.Connected = false
	end
	
	table.insert(
		self.Connections, dictionary
	)
	return dictionary
end

function module:Fire(
	... : kwargs
)
	
	for _, instance in self.Connections do
		
		if instance.Connected then
			
			task.spawn(
				instance.Function, ...
			)
		end
	end
end

function module:Disconnect(
)
	
	for _, instance in self.Connections do
		
		instance.Connected = false
	end
	table.clear(
		self.Connections
	)
end

return module
